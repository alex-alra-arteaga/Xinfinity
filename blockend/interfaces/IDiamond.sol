// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import { IUniswapV3Pool } from "../interfaces/IUniswapV3Pool.sol";

interface IDiamond {
    function estimateWXDConXUSDT(uint128 amountIn, uint32 secondsAgo) external view returns (uint256 amountOut);
    function estimatePriceSupportedPools(address tokenA, address tokenB, uint24 poolFee, uint128 amountIn, uint32 secondsAgo, bool isXSwapPool) external view returns (uint256 amountOut);
    function positionHealthFactorFutures(IUniswapV3Pool pool, address owner, uint24 contractId) external view returns (bool isLiquidable, int256 actualMarginPercentage, int256 actualMarginAmount);
    function mintNewPosXinfin(uint256 amount0ToMint, uint256 amount1ToMint, int24 tickDesired, uint256 poolFee, address token0, address token1) external returns (uint256 tokenId, uint128 liquidity, uint256 amount0, uint256 amount1);
}