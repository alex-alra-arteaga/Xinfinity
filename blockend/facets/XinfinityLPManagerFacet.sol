// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {Modifiers} from "../libraries/Modifiers.sol";
import {Constants} from "../libraries/Constants.sol";
import {IUniswapV3Pool} from "../interfaces/IUniswapV3Pool.sol";
import {TickMath} from "../libraries/TickMath.sol";
import {IERC721Receiver} from "../interfaces/IERC721Receiver.sol";
import {ISwapRouter} from "../interfaces/ISwapRouter.sol";
import {INonfungiblePositionManager} from "../interfaces/INonfungiblePositionManager.sol";
import {TransferHelper} from "../libraries/TransferHelper.sol";
import {Constants} from "../libraries/Constants.sol";
import {Types} from "../libraries/Types.sol";

// use this contract to manage our own pool
contract XinfinityLPManagerFacet is Modifiers, IERC721Receiver {
    // when the contract receive a NFT == liquidity position (can recieve custody of the NFT)

    /**
     *
     * @param operator operator
     * @param tokenId  tokenId of the Liquidity representation NFT
     */

    // triggered when manager recieves a Liquidity representation NFT of Xinfinity Pools
    function onERC721Received(address operator, address, uint256 tokenId, bytes calldata)
        external
        override
        returns (bytes4)
    {
        // in case we receive the nft
        _createDeposit(operator, tokenId);
        return this.onERC721Received.selector;
    }

    /**
     *
     * @param owner owner of the NFT
     * @param tokenId  tokenId of the Liquidity representation NFT
     */

    // crete the deposit using the NonfungiblePositionManager
    function _createDeposit(address owner, uint256 tokenId) internal {
        (address token0, address token1, uint128 liquidity) =
            INonfungiblePositionManager(s.xinfinityManager).positions1(tokenId);

        // set the owner and data for position
        // operator is msg.sender
        // get info from the tokenId
        s.depositsXinfinity[tokenId] =
            Types.Deposit({owner: owner, liquidity: liquidity, token0: token0, token1: token1});
    }

    // mint new position using the NonfungiblePositionManager of Xinfinity, return the tokenID of liquidity
    /**
     *
     * @param amount0ToMint  amount 0 in the pool
     * @param amount1ToMint  amoutn 1 in the pool
     * @param tickDesired Preferred tick range for the position.
     * @param poolFee  Fee tier of the pool for the position.
     * @param token0  token 0 of the pool
     * @param token1  token 1 of the pool
     * @return tokenId
     * @return liquidity
     * @return amount0
     * @return amount1
     */

    function mintNewPosXinfin(
        uint256 amount0ToMint,
        uint256 amount1ToMint,
        int24 tickDesired,
        uint24 poolFee,
        address token0,
        address token1
    ) external returns (uint256 tokenId, uint128 liquidity, uint256 amount0, uint256 amount1) {
        require(s.poolRegistry[token0][token1][poolFee] != address(0), "PoolController: Pool does not exist");
        require(tickDesired > TickMath.MIN_TICK && tickDesired < TickMath.MAX_TICK, "PoolController: Invalid tick");

        // check -> valid pool?
        // check -> valid tick?
        // check -> collateral

        // 1. PREMIUM + COLLATERALL AMOUNT (USER SEND TO THE CONTRACT)
        // amount to mint is collaterall  -> premium for token

        // right on mint the lp is for us..
        // collect the fee form the pool in the tick??

        // 2. BORROW FROM THE XINFINITY POOL WITH LPs NFTS (we have tracking of how much the protocol owes to the lp since we are borrowing from them)
        // 3. With these NFTs we withdraw the liquidity from the Xinfinity pool, and send it along with the collateral + premium of the user to the xSwap pool
        // 3.1 Swap not wanted token for wanted token on our pool
        // 4. Pool Controller gets ownership of LP NFT of xSwap for when the OptionBuyer buys the option

        TransferHelper.safeApprove(token0, address(s.xinfinityManager), amount0ToMint);
        TransferHelper.safeApprove(token1, address(s.xinfinityManager), amount1ToMint);

        INonfungiblePositionManager.MintParams memory params = INonfungiblePositionManager.MintParams({
            token0: token0,
            token1: token1,
            fee: poolFee,
            tickLower: tickDesired - ((Constants.LIQUIDITY_WIDTH * tickDesired) / 1000), // 10 % of the tickDesired
            tickUpper: tickDesired + ((Constants.LIQUIDITY_WIDTH * tickDesired) / 1000), // 10 % of the tickDesired
            amount0Desired: amount0ToMint,
            amount1Desired: amount1ToMint,
            amount0Min: 0, // see this
            amount1Min: 0, // see this
            recipient: address(this), // will trigger the onReceived
            deadline: block.timestamp
        });

        // Note that the pool defined by DAI/USDC and fee tier 0.3% must already be created and initialized in order to mint
        (tokenId, liquidity, amount0, amount1) = INonfungiblePositionManager(s.xinfinityManager).mint(params);
        // Create a deposit for the user
        _createDeposit(msg.sender, tokenId);

        // Remove allowance and refund in both assets.
        if (amount0 < amount0ToMint) {
            TransferHelper.safeApprove(token0, address(s.xinfinityManager), 0);
            uint256 refund0 = amount0ToMint - amount0;
            TransferHelper.safeTransfer(token1, msg.sender, refund0);
        }

        if (amount1 < amount1ToMint) {
            TransferHelper.safeApprove(token0, address(s.xinfinityManager), 0);
            uint256 refund1 = amount1ToMint - amount1;
            TransferHelper.safeTransfer(token1, msg.sender, refund1);
        }
    }

    /**
     *
     * @param tokenId tokenId of the Liquidity representation NFT
     * @return amount0
     * @return amount1
     */

    function collectAllFees(uint256 tokenId) external returns (uint256 amount0, uint256 amount1) {
        // Caller must own the ERC721 position
        // Call to safeTransfer will trigger `onERC721Received` which must return the selector else transfer will fail
        INonfungiblePositionManager(s.xinfinityManager).safeTransferFrom(msg.sender, address(this), tokenId);

        // set amount0Max and amount1Max to uint256.max to collect all fees
        // alternatively can set recipient to msg.sender and avoid another transaction in `sendToOwner`
        INonfungiblePositionManager.CollectParams memory params = INonfungiblePositionManager.CollectParams({
            tokenId: tokenId,
            recipient: address(this),
            amount0Max: type(uint128).max,
            amount1Max: type(uint128).max
        });

        (amount0, amount1) = INonfungiblePositionManager(s.xinfinityManager).collect(params);
        _sendToOwner(tokenId, amount0, amount1);
    }

    /**
     *
     * @param tokenId tokenId of the Liquidity representation NFT
     */

    function retrieveNFT(uint256 tokenId) external {
        // must be the owner of the NFT
        require(msg.sender == s.depositsXinfinity[tokenId].owner, "Not the owner");
        // transfer ownership to original owner
        INonfungiblePositionManager(s.xinfinityManager).safeTransferFrom(address(this), msg.sender, tokenId);
        //remove information related to tokenId
        delete s.depositsXinfinity[tokenId];
    }

    // increse / decrease liquidity
    // need ot pass tokenIds form the same pool

    /**
     *
     * @param tokenIds array of tokenIds of the Liquidity representation NFT
     * @param amount  amount of liquidity to decrease
     * @param isZeroToken  if the token is the zero token
     * @return totalAmount0
     * @return totalAmount1
     */

    function decreaseNecessaryLiquidity(uint256[] memory tokenIds, uint256 amount, bool isZeroToken)
        external
        returns (uint256 totalAmount0, uint256 totalAmount1)
    {
        // Initial check to ensure the caller owns all the tokenIds
        for (uint256 i = 0; i < tokenIds.length; i++) {
            require(msg.sender == s.depositsXinfinity[tokenIds[i]].owner, "Not the owner of all tokenIds");
        }

        // Iterate through the array of tokenIds and decrease liquidity
        for (uint256 i = 0; i < tokenIds.length; i++) {
            uint256 tokenId = tokenIds[i];
            uint128 liquidity = s.depositsXinfinity[tokenId].liquidity;
            uint128 halfLiquidity = liquidity / 2;

            INonfungiblePositionManager.DecreaseLiquidityParams memory params = INonfungiblePositionManager
                .DecreaseLiquidityParams({
                tokenId: tokenId,
                liquidity: halfLiquidity,
                amount0Min: 0,
                amount1Min: 0,
                deadline: block.timestamp
            });

            (uint256 amount0, uint256 amount1) =
                INonfungiblePositionManager(s.xinfinityManager).decreaseLiquidity(params);

            totalAmount0 += amount0;
            totalAmount1 += amount1;

            // Check if we've accumulated enough and stop if we have
            if (isZeroToken && totalAmount0 >= amount) {
                // money back to pool
                increaseLiquidityCurrentRange(tokenId, 0, totalAmount1);
                break;
            }
            if (!isZeroToken && totalAmount1 >= amount) {
                // money back to pool
                increaseLiquidityCurrentRange(tokenId, totalAmount0, 0);
                break;
            }
        }
    }

    // only decrease liquidity in HALF

    function decreaseLiquidityInHalf(uint256[] memory tokenIds) external returns (uint256 amount0, uint256 amount1) {
        uint256 length = tokenIds.length;

        for (uint256 i; i < length;) {
            uint256 tokenId = tokenIds[i];
            // caller must be the owner of the NFT
            require(msg.sender == s.depositsXinfinity[tokenId].owner, "Not the owner");
            // get liquidity data for tokenId
            uint128 liquidity = s.depositsXinfinity[tokenId].liquidity;
            uint128 halfLiquidity = liquidity / 2;
            // amount0Min and amount1Min are price slippage checks
            // if the amount received after burning is not greater than these minimums, transaction will fail
            INonfungiblePositionManager.DecreaseLiquidityParams memory params = INonfungiblePositionManager
                .DecreaseLiquidityParams({
                tokenId: tokenId,
                liquidity: halfLiquidity,
                amount0Min: 0,
                amount1Min: 0,
                deadline: block.timestamp
            });

            (amount0, amount1) = INonfungiblePositionManager(s.xinfinityManager).decreaseLiquidity(params);

            //send liquidity back to owner
            _sendToOwner(tokenId, amount0, amount1);
            unchecked {
                ++i;
            }
        }
    }

    function _sendToOwner(uint256 tokenId, uint256 amount0, uint256 amount1) internal {
        // get owner of contract
        address owner = s.depositsXinfinity[tokenId].owner;

        address token0 = s.depositsXinfinity[tokenId].token0;
        address token1 = s.depositsXinfinity[tokenId].token1;
        // send collected fees to owner
        TransferHelper.safeTransfer(token0, owner, amount0);
        TransferHelper.safeTransfer(token1, owner, amount1);
    }

    /**
     *
     * @param tokenId tokenId of the Liquidity representation NFT
     * @param amountAdd0 amount of token 0 to add
     * @param amountAdd1 amount of token 1 to add
     * @return liquidity
     * @return amount0
     * @return amount1
     */

    function increaseLiquidityCurrentRange(uint256 tokenId, uint256 amountAdd0, uint256 amountAdd1)
        public
        returns (uint128 liquidity, uint256 amount0, uint256 amount1)
    {
        TransferHelper.safeTransferFrom(s.depositsXinfinity[tokenId].token0, msg.sender, address(this), amountAdd0);
        TransferHelper.safeTransferFrom(s.depositsXinfinity[tokenId].token1, msg.sender, address(this), amountAdd1);

        TransferHelper.safeApprove(s.depositsXinfinity[tokenId].token0, address(s.xinfinityManager), amountAdd0);
        TransferHelper.safeApprove(s.depositsXinfinity[tokenId].token1, address(s.xinfinityManager), amountAdd1);

        INonfungiblePositionManager.IncreaseLiquidityParams memory params = INonfungiblePositionManager
            .IncreaseLiquidityParams({
            tokenId: tokenId,
            amount0Desired: amountAdd0,
            amount1Desired: amountAdd1,
            amount0Min: 0,
            amount1Min: 0,
            deadline: block.timestamp
        });

        (liquidity, amount0, amount1) = INonfungiblePositionManager(s.xinfinityManager).increaseLiquidity(params);
    }
}
