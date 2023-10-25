// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {Errors} from "../libraries/Errors.sol";
import {Constants} from "../libraries/Constants.sol";
import { Modifiers } from "../libraries/Modifiers.sol";
import { OracleLibrary, IUniswapV3Pool } from "../lib/v3-core/contracts/libraries/UniswapOracleLibrary.sol";

contract TWAPFacet is Modifiers{
    function estimateWXDConXUSDT(uint128 amountIn, uint32 secondsAgo)
        external
        view
        returns (uint256 amountOut)
    {
        uint32[] memory secondsAgos = new uint32[](2);
        secondsAgos[0] = secondsAgo;
        secondsAgos[1] = 0;

        (int56[] memory tickCumulatives,) =
            IUniswapV3Pool(Constants.XUSDT_WXDC).observe(secondsAgos);

        int56 tickCumulativesDelta = tickCumulatives[1] - tickCumulatives[0];
        int24 tick = int24(tickCumulativesDelta / int32(secondsAgo));

        if (tickCumulativesDelta < 0 && (tickCumulativesDelta % int32(secondsAgo) != 0)) tick--;

        amountOut = OracleLibrary.getQuoteAtTick(tick, amountIn, Constants.WXDC, Constants.XUSDT);
    }

    function estimatePriceSupportedPools(address tokenA, address tokenB, uint24 poolFee, uint128 amountIn, uint32 secondsAgo, bool isXSwapPool)
        external
        view
        returns (uint256 amountOut)
    {
        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        address pool = isXSwapPool ? Constants.XSWAP_V3_FACTORY.getPool(token0, token1, poolFee) : s.poolRegistry[token0][token1][poolFee];
        if (pool == address(0)) revert Errors.NotExistingPool(token0, token1, poolFee);

        uint32[] memory secondsAgos = new uint32[](2);
        secondsAgos[0] = secondsAgo;
        secondsAgos[1] = 0;

        (int56[] memory tickCumulatives,) =
            IUniswapV3Pool(pool).observe(secondsAgos);

        int56 tickCumulativesDelta = tickCumulatives[1] - tickCumulatives[0];
        int24 tick = int24(tickCumulativesDelta / int32(secondsAgo));

        if (tickCumulativesDelta < 0 && (tickCumulativesDelta % int32(secondsAgo) != 0)) tick--;

        amountOut = OracleLibrary.getQuoteAtTick(tick, amountIn, token0, token1);
    }
}
