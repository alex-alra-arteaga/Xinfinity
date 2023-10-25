// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import { Modifiers } from "../libraries/Modifiers.sol";
import {IDiamond} from "../interfaces/IDiamond.sol";
import {Errors} from "../libraries/Errors.sol";
import {Types} from "../libraries/Types.sol";
import { IERC20 } from "../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import { IUniswapV3Pool } from "../lib/v3-core/contracts/interfaces/IUniswapV3Pool.sol";

contract LeverageFacet is Modifiers {
    
    function increaseCollateralFutures(IUniswapV3Pool pool, uint24 contractId) external {
        Types.PerpFuture memory future = s.futureRecord[pool][msg.sender][contractId];
        if (future.status != Types.OrderStatus.MINTED && future.status != Types.OrderStatus.BOUGHT) revert Errors.NotAvaibleFuture(pool, msg.sender, contractId);

        IERC20(future.collateralToken).transferFrom(msg.sender, address(this), amount);

        s.futureRecord[pool][msg.sender][contractId].collateralAmount += amount;

        // new leverage cannot be lower than 1x
        if (future.collateralAmount + amount < future.borrowAmount) revert Errors.IncorrectLeverage();
    }

    function decreaseCollateralFutures(IUniswapV3Pool pool, uint24 contractId, uint256 amount) external {
        Types.PerpFuture memory future = s.futureRecord[pool][msg.sender][contractId];
        if (future.status != Types.OrderStatus.MINTED && future.status != Types.OrderStatus.BOUGHT) revert Errors.NotAvaibleFuture(pool, msg.sender, contractId);

        (bool isLiquidable, int256 actualMarginPercentage, int256 actualMarginAmount) = IDiamond(address(this)).positionHealthFactorFutures(pool, owner, contractId);
        if (isLiquidable || amount < uint256(-actualMarginAmount)) revert Errors.PositionsIsLiquidable();

        IERC20(future.collateralToken).transferFrom(address(this), msg.sender, amount);

        s.futureRecord[pool][msg.sender][contractId].collateralAmount -= amount;

        // new leverage cannot be greater than 100x
        if ((future.collateralAmount + amount) * 100 < future.borrowAmount) revert Errors.IncorrectLeverage();
    }

    function increaseCollateralOptions(IUniswapV3Pool pool, uint24 contractId) external {
        Types.PerpOption memory option = s.optionRecord[pool][msg.sender][contractId];
        if (option.status != Types.OrderStatus.MINTED && option.status != Types.OrderStatus.BOUGHT) revert Errors.NotAvailableOption(pool, msg.sender, contractId);

        IERC20(option.collateralToken).transferFrom(msg.sender, address(this), amount);

        s.optionRecord[pool][msg.sender][contractId].collateralAmount += amount;

        // new leverage cannot be lower than 1x
        if (option.collateralAmount + amount < option.borrowAmount) revert Errors.IncorrectLeverage();
    }

    function decreaseCollateralOptions(IUniswapV3Pool pool, uint24 contractId) external {
        Types.PerpOption memory option = s.optionRecord[pool][msg.sender][contractId];
        if (option.status != Types.OrderStatus.MINTED && option.status != Types.OrderStatus.BOUGHT) revert Errors.NotAvailableOption(pool, msg.sender, contractId);

        IERC20(option.collateralToken).transferFrom(address(this), msg.sender, amount);

        s.optionRecord[pool][msg.sender][contractId].collateralAmount -= amount;

        // new leverage cannot be greater than 100x
        if ((option.collateralAmount + amount) * 100 < option.borrowAmount) revert Errors.IncorrectLeverage();
    }
}