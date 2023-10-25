// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import { IUniswapV3Pool } from "../interfaces/IUniswapV3Pool.sol";
import {TickMath} from "../libraries/TickMath.sol";
import {IERC721Receiver} from "../interfaces/IERC721Receiver.sol";
import {ISwapRouter} from "../interfaces/ISwapRouter.sol";
import {INonfungiblePositionManager} from "../interfaces/INonfungiblePositionManager.sol";
import {TransferHelper} from "../libraries/TransferHelper.sol";
import {Constants} from "../libraries/Constants.sol";

// POOL CONTROLLOR OF UNISWAP interacting with xSwap 
contract PoolControllerFacet is Modifiers, IERC721Receiver {
    // when the contract receive a NFT == liquidity position (can recieve custody of the NFT)
    function onERC721Received(address operator, address, uint256 tokenId, bytes calldata)
        external
        override
        returns (bytes4)
    {
        // in case we recieve the nft
        _createDeposit(operator, tokenId);
        return this.onERC721Received.selector;
    }

    function _createDeposit(address owner, uint256 tokenId) internal {
        (,, address token0, address token1,,,, uint128 liquidity,,,,) = ConnonfungiblePositionManager.positions(tokenId);

        // set the owner and data for position
        // operator is msg.sender

        // get info from the tokenId
        s.depositXswap[tokenId] = Deposit({owner: owner, liquidity: liquidity, token0: token0, token1: token1 });
    }

    function mintNewPosXinfin(uint256 amountOToMint, uint256 amount1ToMint, uint256 tickDesired, uint256 poolFee)
        external
        returns (uint256 tokenId, uint128 liquidity, uint256 amount0, uint256 amount1)
    {
        require(s.poolRegistry[token0][token1][poolFee] != address(0), "PoolController: Pool does not exist");
        require(tickDesired > TickMath.MIN_TICK && tickDesired < TickMath.MAX_TICK, "PoolController: Invalid tick");

        // check -> valid pool?
        // check -> valid tick?
        // check -> collateral

        // 1. PREMIUM + COLLATERALL AMOUNT (USER SEND TO THE CONTRACT)
        // 2. BORROW FROM THE XINFINITY POOL WITH LPs NFTS (we have tracking of how much the protocol owes to the lp since we are borrowing from them)
        // 3. With these NFTs we withdraw the liquidity from the Xinfinity pool, and send it along with the collateral + premium of the user to the xSwap pool
           // 3.1 Swap not wanted token for wanted token on our pool
        // 4. Pool Controller gets ownership of LP NFT of xSwap for when the OptionBuyer buys the option


        TransferHelper.safeApprove(token0, address(Constants.NON_FUNGIBLE_POSITION_MANAGER), amount0ToMint);
        TransferHelper.safeApprove(token1, address(Constants.NON_FUNGIBLE_POSITION_MANAGER), amount1ToMint);


        INonfungiblePositionManager.MintParams memory params =
            INonfungiblePositionManager.MintParams({
                token0: token0,
                token1: token1,
                fee: poolFee,
                tickLower: tickDesired - (Constants.LIQUIDITY_WIDTH * tickDesired / 1000), // 10 % of the tickDesired
                tickUpper: tickDesired + (Constants.LIQUIDITY_WIDTH * tickDesired / 1000), // 10 % of the tickDesired
                amount0Desired: amount0ToMint,
                amount1Desired: amount1ToMint,
                amount0Min: 0, // always should be defined by user, but for hackathon simplicity we will set it to 0
                amount1Min: 0, // always should be defined by user, but for hackathon simplicity we will set it to 0
                recipient: address(this), // will trigger the onReceived
                deadline: block.timestamp
            });

        // Note that the pool defined by DAI/USDC and fee tier 0.3% must already be created and initialized in order to mint
        (tokenId, liquidity, amount0, amount1) = Constants.NON_FUNGIBLE_POSITION_MANAGER.mint(params);
          // Create a deposit for the user
        _createDeposit(msg.sender, tokenId);

        // Remove allowance and refund in both assets.
        if (amount0 < amount0ToMint) {
            TransferHelper.safeApprove(DAI, address(Constants.NON_FUNGIBLE_POSITION_MANAGER), 0);
            uint256 refund0 = amount0ToMint - amount0;
            TransferHelper.safeTransfer(DAI, msg.sender, refund0);
        }

        if (amount1 < amount1ToMint) {
            TransferHelper.safeApprove(USDC, address(Constants.NON_FUNGIBLE_POSITION_MANAGER), 0);
            uint256 refund1 = amount1ToMint - amount1;
            TransferHelper.safeTransfer(USDC, msg.sender, refund1);
        }

    }

    function collectAllFeesXinfin(uint256 tokenId) external returns (uint256 amount0, uint256 amount1) {
        // Caller must own the ERC721 position
        // Call to safeTransfer will trigger `onERC721Received` which must return the selector else transfer will fail
        Constants.NON_FUNGIBLE_POSITION_MANAGER.safeTransferFrom(msg.sender, address(this), tokenId);

        // set amount0Max and amount1Max to uint256.max to collect all fees
        // alternatively can set recipient to msg.sender and avoid another transaction in `sendToOwner`
        INonfungiblePositionManager.CollectParams memory params =
            INonfungiblePositionManager.CollectParams({
                tokenId: tokenId,
                recipient: address(this),
                amount0Max: type(uint128).max,
                amount1Max: type(uint128).max
            });

        (amount0, amount1) = Constants.NON_FUNGIBLE_POSITION_MANAGER.collect(params);

        // send collected feed back to owner
        _sendToOwner(tokenId, amount0, amount1);
    }

    function _sendToOwner(
        uint256 tokenId,
        uint256 amount0,
        uint256 amount1
    ) internal {
        // get owner of contract
        address owner = s.depositXswap[tokenId].owner;

        address token0 = s.depositXswap[tokenId].token0;
        address token1 = s.depositXswap[tokenId].token1;
        // send collected fees to owner
        TransferHelper.safeTransfer(token0, owner, amount0);
        TransferHelper.safeTransfer(token1, owner, amount1);
    }

     function decreaseAllLiquidity(uint256 tokenId) external returns (uint256 amount0, uint256 amount1) {
        // caller must be the owner of the NFT
        require(msg.sender == s.depositXswap[tokenId].owner || msg.sender == s.owner, 'Not the owner');
        // get liquidity data for tokenId
        uint128 liquidity = s.depositXswap[tokenId].liquidity;
        uint128 halfLiquidity = liquidity;

        // amount0Min and amount1Min are price slippage checks
        // if the amount received after burning is not greater than these minimums, transaction will fail
        INonfungiblePositionManager.DecreaseLiquidityParams memory params =
            INonfungiblePositionManager.DecreaseLiquidityParams({
                tokenId: tokenId,
                liquidity: halfLiquidity,
                amount0Min: 0,
                amount1Min: 0,
                deadline: block.timestamp
            });

        (amount0, amount1) = Constants.NON_FUNGIBLE_POSITION_MANAGER.decreaseLiquidity(params);

        //send liquidity back to owner
        _sendToOwner(tokenId, amount0, amount1);
    }

      function increaseLiquidityCurrentRangeXinfin(
        uint256 tokenId,
        uint256 amountAdd0,
        uint256 amountAdd1
    )
        external
        returns (
            uint128 liquidity,
            uint256 amount0,
            uint256 amount1
        ) {

        TransferHelper.safeTransferFrom(s.depositXswap[tokenId].token0, msg.sender, address(this), amountAdd0);
        TransferHelper.safeTransferFrom(s.depositXswap[tokenId].token1, msg.sender, address(this), amountAdd1);

        TransferHelper.safeApprove(s.depositXswap[tokenId].token0, address(Constants.NON_FUNGIBLE_POSITION_MANAGER), amountAdd0);
        TransferHelper.safeApprove(s.depositXswap[tokenId].token1, address(Constants.NON_FUNGIBLE_POSITION_MANAGER), amountAdd1);

        INonfungiblePositionManager.IncreaseLiquidityParams memory params = INonfungiblePositionManager.IncreaseLiquidityParams({
            tokenId: tokenId,
            amount0Desired: amountAdd0,
            amount1Desired: amountAdd1,
            amount0Min: 0,
            amount1Min: 0,
            deadline: block.timestamp
        });

        (liquidity, amount0, amount1) = Constants.NON_FUNGIBLE_POSITION_MANAGER.increaseLiquidity(params);

    }

     function retrieveNFTXinfin(uint256 tokenId) external {
        // must be the owner of the NFT
        require(msg.sender == s.depositXswap[tokenId].owner, 'Not the owner');
        // transfer ownership to original owner
        nonfungiblePositionManager.safeTransferFrom(address(this), msg.sender, tokenId);
        //remove information related to tokenId
        delete s.depositXswap[tokenId];
    }


    }
