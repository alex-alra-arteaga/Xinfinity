// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {Constants} from "./Constants.sol";
import { Errors } from "./Errors.sol";
import { IDiamond } from "../interfaces/IDiamond.sol";

library TWAPOracle {
    function getPoolTWAP(address tokenA, address tokenB, uint24 poolFee, uint128 amountIn, bool isXSwapPool) internal view returns (uint256) {
        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);

        bool isBaseTokenWXDC = token1 == Constants.WXDC;
        bool isBaseTokenXUSDT = token1 == Constants.XUSDT;

        uint256 twapPrice = IDiamond(address(this)).estimateWXDConXUSDT(
            amountIn, 10 hours
        ); // wXDC per xUSDT

        if (isBaseTokenWXDC) {
            return 1e36 / twapPrice;
        } else if (isBaseTokenXUSDT) {
            return IDiamond(address(this)).estimatePriceSupportedPools(token0, token1, poolFee, amountIn, 10 hours, isXSwapPool);
        } else {
            revert Errors.NotSupportedPool();
        }
    }
    
    /**
     * @notice xSwap pool price / Xinfinity pool price
     * @return ratio of xSwap pool / Xinfinity pool in basis points
     */
    function getRatioXinfinityXSwapPool(address tokenA, address tokenB, uint24 poolFee, uint128 amountIn) internal view returns (uint256) {
        return getPoolTWAP(tokenA, tokenB, poolFee, amountIn, true) / getPoolTWAP(tokenA, tokenB, poolFee, amountIn, false) * Constants.BASIS_POINTS;
    }
}