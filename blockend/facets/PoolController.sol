// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {IUniswapV3Pool} from "../lib/v3-core/contracts/interfaces/IUniswapV3Pool.sol";
import {TickMath} from "../lib/v3-core/contracts/libraries/TickMath.sol";
import {IERC721Receiver} from "../lib/openzeppelin-contracts/contracts/token/ERC721/IERC721Receiver.sol";
import {ISwapRouter} from "../lib/v3-periphery/contracts/interfaces/ISwapRouter.sol";
import {INonfungiblePositionManager} from "../lib/v3-periphery/contracts/interfaces/INonfungiblePositionManager.sol";
import {TransferHelper} from "../lib/v3-periphery/contracts/libraries/TransferHelper.sol";
import {LiquidityManagement} from "../lib/v3-periphery/contracts/base/LiquidityManagement.sol";
import {Constants} from "../libraries/Constants.sol";

// PeripheryImmutableState(_factory, _WETH9) ?
// need the other contract crate the ManagePosition
contract PoolController is Modifiers, IERC721Receiver {
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
        deposits[tokenId] = Deposit({owner: owner, liquidity: liquidity, token0: token0, token1: token1 });
    }

    function mintNewPos(uint256 amountOToMint, uint256 amount1ToMint, uint256 tickDesired, uint256 premium, uint256 poolFee)
        external
        returns (uint256 tokenId, uint128 liquidity, uint256 amount0, uint256 amount1)
    {
        require(s.poolRegistry[token0][token1][poolFee] != address(0), "PoolController: Pool does not exist");
        require(tickDesired > TickMath.MIN_TICK && tickDesired < TickMath.MAX_TICK, "PoolController: Invalid tick");

        // check -> valid pool?
        // check -> valid tick?
        // check -> collateral

        // 1. PREMIUM + COLLATERALL AMOUNT (USER SEND TO THE CONTRACT)
        // amount to mint is collaterall  -> premium for token

        // right on mint the lp is for us..

        // No manager -> need to collect
        s.poolRegistry[token0][token1][poolFee].collect(address(this), TickMath.MIN_TICK, TickMath.MAX_TICK, amount0ToMint, amount1ToMint);
        // collect the fee form the pool in the tick??

        // 2. BORROW FROM THE XINFINITY POOL WITH LPs NFTS (we have tracking of how much the protocol owes to the lp since we are borrowing from them)
        // 3. With these NFTs we withdraw the liquidity from the Xinfinity pool, and send it along with the collateral + premium of the user to the xSwap pool
           // 3.1 Swap not wanted token for wanted token on our pool
        // 4. Pool Controller gets ownership of LP NFT of xSwap for when the OptionBuyer buys the option


        TransferHelper.safeApprove(token0, address(nonfungiblePositionManager), amount0ToMint + premium);
        TransferHelper.safeApprove(token1, address(nonfungiblePositionManager), amount1ToMint + premium);


        INonfungiblePositionManager.MintParams memory params =
            INonfungiblePositionManager.MintParams({
                token0: token0,
                token1: token1,
                fee: poolFee,
                tickLower: tickDesired + (Constants.LIQUIDITY_WIDTH * tickDesired / 1000) // 10 % of the tickDesired
                tickUpper: tickDesired - (Constants.LIQUIDITY_WIDTH * tickDesired / 1000) // 10 % of the tickDesired
                amount0Desired: amount0ToMint,
                amount1Desired: amount1ToMint,
                amount0Min: 0, // see this
                amount1Min: 0, // see this
                recipient: address(this), // will trigger the onReceived
                deadline: block.timestamp
            });

        // Note that the pool defined by DAI/USDC and fee tier 0.3% must already be created and initialized in order to mint
        (tokenId, liquidity, amount0, amount1) = Constants.NON_FUNGIBLE_POSITION_MANAGER.mint(params);
          // Create a deposit for the user
        _createDeposit(msg.sender, tokenId);

        // Remove allowance and refund in both assets.
        if (amount0 < amount0ToMint) {
            TransferHelper.safeApprove(DAI, address(nonfungiblePositionManager), 0);
            uint256 refund0 = amount0ToMint - amount0;
            TransferHelper.safeTransfer(DAI, msg.sender, refund0);
        }

        if (amount1 < amount1ToMint) {
            TransferHelper.safeApprove(USDC, address(nonfungiblePositionManager), 0);
            uint256 refund1 = amount1ToMint - amount1;
            TransferHelper.safeTransfer(USDC, msg.sender, refund1);
        }

        function collectAllFees(uint256 tokenId) external returns (uint256 amount0, uint256 amount1) {
        // Caller must own the ERC721 position
        // Call to safeTransfer will trigger `onERC721Received` which must return the selector else transfer will fail
        nonfungiblePositionManager.safeTransferFrom(msg.sender, address(this), tokenId);

        // set amount0Max and amount1Max to uint256.max to collect all fees
        // alternatively can set recipient to msg.sender and avoid another transaction in `sendToOwner`
        INonfungiblePositionManager.CollectParams memory params =
            INonfungiblePositionManager.CollectParams({
                tokenId: tokenId,
                recipient: address(this),
                amount0Max: type(uint128).max,
                amount1Max: type(uint128).max
            });

        (amount0, amount1) = nonfungiblePositionManager.collect(params);

        // send collected feed back to owner
        _sendToOwner(tokenId, amount0, amount1);

            /// @notice Transfers funds to owner of NFT
    /// @param tokenId The id of the erc721
    /// @param amount0 The amount of token0
    /// @param amount1 The amount of token1
    function _sendToOwner(
        uint256 tokenId,
        uint256 amount0,
        uint256 amount1
    ) internal {
        // get owner of contract
        address owner = deposits[tokenId].owner;

        address token0 = deposits[tokenId].token0;
        address token1 = deposits[tokenId].token1;
        // send collected fees to owner
        TransferHelper.safeTransfer(token0, owner, amount0);
        TransferHelper.safeTransfer(token1, owner, amount1);
    }
        }

    }
}
