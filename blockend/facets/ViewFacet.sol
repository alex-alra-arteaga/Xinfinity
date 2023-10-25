// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {Modifiers} from "../libraries/Modifiers.sol";
import {Types} from "../libraries/Types.sol";
import {Errors} from "../libraries/Errors.sol";
import { TWAPOracle } from "../libraries/TWAPOracle.sol";
import { IUniswapV3Pool } from "../lib/v3-core/contracts/interfaces/IUniswapV3Pool.sol";

/// @dev Used to view data from the AppStorage
contract ViewFacet is Modifiers {

    function positionHealthFactorFutures(IUniswapV3Pool pool, address owner, uint24 contractId) external view returns (uint256) {
        Types.PerpFuture memory future = s.futureRecord[address(pool)][owner][contractId];
        int256 priceDiffInPercentage = int256(((TWAPOracle.getPoolTWAP(pool.token0(), pool.token1(), pool.fee(), future.collateralAmount, true) / future.collateralAmount) * future.initialPrice) / future.initialPrice);
        int256 profitInPercentage = future.futureType == Types.FutureType.CALL ? priceDiffInPercentage : -priceDiffInPercentage;
        if (profitInPercentage < int256(future.maintenanceMargin)) revert Errors.CollateralBelowMaintenanceMargin(priceDiffInPercentage, future.maintenanceMargin);
    }
}