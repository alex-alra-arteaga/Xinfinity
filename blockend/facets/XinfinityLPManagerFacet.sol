// SPDX-License-Identifier: MIT

import {Modifiers} from "../libraries/Modifiers.sol";
import {Constants} from "../libraries/Constants.sol";

pragma solidity 0.8.19;

// @audit - This contract is responsible for managing liquidity pools on top of uniswap
contract XinfinLPManagerFacet is Modifiers {
    function depositAllLiquidity(
        address recipient,
        int24 tickLower,
        int24 tickUpper,
        uint128 amount,
        address token0,
        address token1,
        uint256 poolFee
    ) external returns (uint256 amount0, uint256 amount1) {
        require(outToken == token0 || outToken == token1, "XinfinLPManagerFacet: Invalid out token");
        require(amount > 0, "XinfinLPManagerFacet: Invalid amount");
        require(
            tickLower > TickMath.MIN_TICK && tickLower < TickMath.MAX_TICK, "XinfinLPManagerFacet: Invalid tick lower"
        );
        require(recipient == address(this)); // need to have the lp in our contract but can claim

        IUniswapV3Pool pool = s.poolRegistry[token0][token1][poolFee];
        (amount0, amount1) = pool.mint(recipient, tickLower, tickUpper, amount, ""); //
    }

    function depositLiquidity(
        address recipient,
        int24 tickLower,
        int24 tickUpper,
        uint128 amount,
        address token0,
        address token1,
        uint256 poolFee
    ) external {
        // we get our pool form the registry
        IUniswapV3Pool pool = s.poolRegistry[token0][token1][poolFee];
        // check for the outToken to be valid
        require(outToken == token0 || outToken == token1, "XinfinLPManagerFacet: Invalid out token");
        // check for the amount to be valid
        require(amount > 0, "XinfinLPManagerFacet: Invalid amount");
        // check for the tick to be valid
        require(
            tickLower > TickMath.MIN_TICK && tickLower < TickMath.MAX_TICK, "XinfinLPManagerFacet: Invalid tick lower"
        );

        // need the recipient of the NFT (position representation) to be our's to manage easily, this does not mena that can't claim anytime
        require(recipient == address(this));
        // mint the NFT position representation + return amount deposited
        (amount0, amount1) = pool.mint(recipient, tickLower, tickUpper, amount, "");
    }

    function withdrawAllLiquidity(
        address recipient,
        int24 tickLower,
        int24 tickUpper,
        uint128 amount,
        address token0,
        address token1,
        uint256 poolFee
    ) external {
        IUniswapV3Pool pool = s.poolRegistry[token0][token1][poolFee];

        // to do this we burn the nft to get the representation

        //  function burn(
        // int24 tickLower,
        // int24 tickUpper,
        // uint128 amount

        pool.burn(tickLower, tickUpper, amount);
    }

    function withdrawLiquidity(
        address recipient,
        int24 tickLower,
        int24 tickUpper,
        uint128 amount,
        address token0,
        address token1,
        uint256 poolFee
    ) external {
        IUniswapV3Pool pool = s.poolRegistry[token0][token1][poolFee];
    }

    /**
     * Borrow liquidity form our pool
     * @param amountToBorrow
     * @param outToken
     * @param token0
     * @param token1
     * @param poolFee
     */
    function borrowLiquidity(uint256 amountToBorrow, address outToken, address token0, address token1, uint256 poolFee)
        external
    {
        // check for the outToken to be valid
        require(outToken == token0 || outToken == token1, "XinfinLPManagerFacet: Invalid out token");
        // get pool from registry
        IUniswapV3Pool pool = s.poolRegistry[token0][token1][poolFee];

        // collect fess to be able to borrow to user
        (uint128 amount0, uint128 amount1) =
            pool.collect(address(this), TickMath.MIN_TICK, TickMath.MAX_TICK, amount0ToMint, amount1ToMint);

        // swap the token to add the balance ot user operation
        if (outToken == token0) {
            (int256 amount0,) = pool.swap(msg.sender, false, amount1, 0, "");
            TransferHelper.safeTransfer(token0, address(this), amount0);
        } else {
            (, int256 amount1) = pool.swap(msg.sender, true, amount0, 0, "");
            TransferHelper.safeTransfer(token1, address(this), amount1);
        }
    }
}
