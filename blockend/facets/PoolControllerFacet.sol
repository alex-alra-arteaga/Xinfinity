// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {IUniswapV3Pool} from "../interfaces/IUniswapV3Pool.sol";
import {TickMath} from "../libraries/TickMath.sol";
import {ISwapRouter} from "../interfaces/ISwapRouter.sol";
import {INonfungiblePositionManager} from "../interfaces/INonfungiblePositionManager.sol";
import {TransferHelper} from "../libraries/TransferHelper.sol";
import {Constants} from "../libraries/Constants.sol";
import {Modifiers} from "../libraries/Modifiers.sol";
import {Types} from "../libraries/Types.sol";

// POOL CONTROLLOR OF UNISWAP interacting with xSwap
contract PoolControllerFacet is Modifiers {
    // when the contract receive a NFT == liquidity position (can recieve custody of the NFT)
    function collectAllFeesXinfin(uint256 tokenId) external returns (uint256 amount0, uint256 amount1) {
        // Caller must own the ERC721 position
        // Call to safeTransfer will trigger `onERC721Received` which must return the selector else transfer will fail
        Constants.NON_FUNGIBLE_POSITION_MANAGER.safeTransferFrom(msg.sender, address(this), tokenId);

        // set amount0Max and amount1Max to uint256.max to collect all fees
        // alternatively can set recipient to msg.sender and avoid another transaction in `sendToOwner`
        INonfungiblePositionManager.CollectParams memory params = INonfungiblePositionManager.CollectParams({
            tokenId: tokenId,
            recipient: address(this),
            amount0Max: type(uint128).max,
            amount1Max: type(uint128).max
        });

        (amount0, amount1) = Constants.NON_FUNGIBLE_POSITION_MANAGER.collect(params);

        // send collected feed back to owner
        _sendToOwner(tokenId, amount0, amount1);
    }

    /**
     * 
     * @param tokenId tokenId of the Liquidity representation NFT
     * @param amount0 amount of token 0 to send
     * @param amount1 amount of token 1 to send
     */

    // return collected fees to owner
    function _sendToOwner(uint256 tokenId, uint256 amount0, uint256 amount1) internal {
        // get owner of contract
        address owner = s.depositXswap[tokenId].owner;

        address token0 = s.depositXswap[tokenId].token0;
        address token1 = s.depositXswap[tokenId].token1;
        // send collected fees to owner
        TransferHelper.safeTransfer(token0, owner, amount0);
        TransferHelper.safeTransfer(token1, owner, amount1);
    }

    /**
     *
     * @param tokenId tokenId  of the Liquidity representation NFT
     * @return amount0
     * @return amount1
     */
    function decreaseAllLiquidity(uint256 tokenId) external returns (uint256 amount0, uint256 amount1) {
        // caller must be the owner of the NFT
        require(msg.sender == s.depositXswap[tokenId].owner || msg.sender == s.admin, "Not the owner");
        // get liquidity data for tokenId
        uint128 liquidity = s.depositXswap[tokenId].liquidity;
        uint128 halfLiquidity = liquidity;

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

        (amount0, amount1) = Constants.NON_FUNGIBLE_POSITION_MANAGER.decreaseLiquidity(params);

        //send liquidity back to owner
        _sendToOwner(tokenId, amount0, amount1);
    }

    /**
     *
     * @param tokenId tokenId of the Liquidity representation NFT
     * @param amountAdd0  amount of token 0 to add
     * @param amountAdd1  amount of token 1 to add
     * @return liquidity
     * @return amount0
     * @return amount1
     */

    function increaseLiquidityCurrentRangeXinfin(uint256 tokenId, uint256 amountAdd0, uint256 amountAdd1)
        external
        returns (uint128 liquidity, uint256 amount0, uint256 amount1)
    {
        TransferHelper.safeTransferFrom(s.depositXswap[tokenId].token0, msg.sender, address(this), amountAdd0);
        TransferHelper.safeTransferFrom(s.depositXswap[tokenId].token1, msg.sender, address(this), amountAdd1);

        TransferHelper.safeApprove(
            s.depositXswap[tokenId].token0, address(Constants.NON_FUNGIBLE_POSITION_MANAGER), amountAdd0
        );
        TransferHelper.safeApprove(
            s.depositXswap[tokenId].token1, address(Constants.NON_FUNGIBLE_POSITION_MANAGER), amountAdd1
        );

        INonfungiblePositionManager.IncreaseLiquidityParams memory params = INonfungiblePositionManager
            .IncreaseLiquidityParams({
            tokenId: tokenId,
            amount0Desired: amountAdd0,
            amount1Desired: amountAdd1,
            amount0Min: 0,
            amount1Min: 0,
            deadline: block.timestamp
        });

        (liquidity, amount0, amount1) = Constants.NON_FUNGIBLE_POSITION_MANAGER.increaseLiquidity(params);
    }

    /**
     *
     * @param tokenId tokenId of the Liquidity representation NFT
     */
    function retrieveNFTXinfin(uint256 tokenId) external {
        // must be the owner of the NFT
        require(msg.sender == s.depositXswap[tokenId].owner, "Not the owner");
        // transfer ownership to original owner
        INonfungiblePositionManager(s.nonfungiblePositionManager).safeTransferFrom(address(this), msg.sender, tokenId);
        //remove information related to tokenId
        delete s.depositXswap[tokenId];
    }
}
