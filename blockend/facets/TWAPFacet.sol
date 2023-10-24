// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {Errors} from "../libraries/Errors.sol";
import {Constants} from "../libraries/Constants.sol";
import { OracleLibrary, IUniswapV3Pool } from "../lib/v3-core/contracts/libraries/UniswapOracleLibrary.sol";

contract TWAPFacet {
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

        amountOut = OracleLibrary.getQuoteAtTick(tick, amountIn, Constants.WETH, Constants.USDC);
    }
}
