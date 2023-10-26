// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import { Modifiers } from "../libraries/Modifiers.sol";
import {IDiamond} from "../interfaces/IDiamond.sol";
import {Errors} from "../libraries/Errors.sol";
import {Types} from "../libraries/Types.sol";
import { IERC20 } from "../interfaces/IERC20.sol";
import { IUniswapV3Pool } from "../interfaces/IUniswapV3Pool.sol";
import { Constants } from "../libraries/Constants.sol";

contract LiquidatorFacet is Modifiers {

    function liquidateFuture(IUniswapV3Pool pool, address owner, uint24 contractId) external {

        (bool isLiquidable, int256 actualMarginPercentage, int256 actualMarginAmount) = IDiamond(address(this)).positionHealthFactorFutures(address(pool), owner, contractId);
        if (!isLiquidable) revert Errors.NotLiquidable();

        Types.PerpFuture memory future = s.futureRecord[address(pool)][owner][contractId];
        // if isLiquidable, actualMarginAmount is negative
        uint amountToPayToLiquidator = uint256(-actualMarginAmount) * pool.fee() / Constants.BASIS_POINTS;

        IERC20(future.collateralToken).transfer(msg.sender, amountToPayToLiquidator);
        IERC20(future.collateralToken).transfer(owner, future.collateralAmount - amountToPayToLiquidator);

        delete s.futureRecord[address(pool)][owner][contractId];
    }
}