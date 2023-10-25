// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import { Modifiers } from "../libraries/Modifiers.sol";
import { Errors } from "../libraries/Errors.sol";
import { Types } from "../libraries/Types.sol";
import { TWAPOracle } from "../libraries/TWAPOracle.sol";
import { IERC20 } from "../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import { IUniswapV3Pool } from "../lib/v3-core/contracts/interfaces/IUniswapV3Pool.sol";
import { TWAPOracle } from "../libraries/TWAPOracle.sol";

contract PerpFuturesFacet is Modifiers {
    
    function buyFutureContract(address pool, address owner, uint256 contractId, Types.FutureType futureType) external {
        if (msg.sender == owner) revert Errors.CannotBuyFromYourself(owner);
        Types.PerpFuture memory futureToBuy = s.futureRecord[pool][owner][contractId];
        if (futureToBuy.status != Types.OrderStatus.MINTED) revert Errors.NotAvaibleFuture(pool, owner, contractId);

        int256 priceDiffInPercentage = ((TWAPOracle.getPoolTWAP(pool.token0(), pool.token1(), pool.fee(), futureToBuy.collateralAmount, true) / futureToBuy.collateralAmount) * futureToBuy.initialPrice) / futureToBuy.initialPrice;
        int256 profitInPercentage = futureToBuy.futureType == Types.FutureType.CALL ? priceDiffInPercentage : -priceDiffInPercentage;
        if (profitInPercentage < int256(futureToBuy.maintenanceMargin)) revert Errors.CollateralBelowMaintenanceMargin(priceDiffInPercentage, futureToBuy.maintenanceMargin);

        IERC20(futureToBuy.collateralToken).transferFrom(msg.sender, owner, futureToBuy.collateralAmount + futureToBuy.fundingRatePayment);

        futureToBuy.status = Types.OrderStatus.BOUGHT;
        s.futureRecord[pool][msg.sender][recordId] = futureToBuy;
        delete s.futureRecord[pool][owner][contractId];
    }

    function sellFutureContract(uint256 amount, address token, address pool, uint24 poolFee, uint24 leverage, Types.FutureType futureType) external {
        address token0 = IUniswapV3Pool(pool).token0();
        address token1 = IUniswapV3Pool(pool).token1();
        if (s.poolRegistry[token0][token1][poolFee] != pool) revert Errors.NotSupportedPool();
        uint256 amountCost = TWAPOracle.getPoolTWAP(token0, token1, poolFee, amount, true);
        uint256 price = amountCost / amount;

        if (leverage > Constants.MAX_LEVERAGE || leverage < Constants.MIN_LEVERAGE) revert Errors.IncorrectLeverage();

        if (token != token0 || token != token1) revert Errors.NotIncludedInPool(token, token0, token1);

        uint256 priceRatio = getRatioXinfinityXSwapPool(token0, token1, poolFee, amount);
        // ((1.01 * 10_000 * 100) / 10_000) - 100 = 1 token  (if xSwap pool price is 1% higher than Xinfinity pool, shorters will pay 1 token more to longers, to raise the price of the pool)
        // ((0.99 * 10_000 * 100) / 10_000) - 100 = -1 token  (if xSwap pool price is 1% lower than Xinfinity pool, shorters will receive 1 token more from longers, to lower the price of the pool)
        int256 fundingRate = ((priceRatio * amount) / Constants.BASIS_POINTS) - amount;
        int256 fundingRatePayment = futureType == Types.FutureType.CALL ? fundingRate : -fundingRate;
        /// @dev due to onlyDiamond modifier, address(this) is the Diamond contract, so PoolController will be able to move the tokens
        IERC20(token).transferFrom(msg.sender, address(this), uint256(int256(amount) + int256(premium) + fundingRatePayment));

        // call PoolController to move liquidity
        IDiamond(address(this)).mintNewPos(token, );

        unchecked {
            recordId = s.numOfRecordFutures[pool][msg.sender]++;
        }
        Types.PerpFuture storage future = s.futureRecord[pool][msg.sender][recordId];
        if (future.status != Types.OrderStatus.UNINITIALIZED) revert Errors.NotAvaibleFuture(pool, owner, contractId);
        future.futureType = futureType;
        future.xinfinityPool = pool;
        future.initialPrice = price;
        future.leverage = leverage;
        future.collateralAmount = amount;
        future.fundingRatePayment = fundingRatePayment;
        future.borrowAmount = (amount * leverage) / Constants.BASIS_POINTS;
        // if leverage is x10, then maintenance margin is 10% of collateral
        future.maintenanceMargin = (100 * Constants.PRECISION / leverage) / (Constants.PRECISION / Constants.BASIS_POINTS);
        future.status = Types.OrderStatus.MINTED;
    }

    function settleFutureContract(address pool, address owner, uint256 contractId) external {
        Types.PerpFuture memory futureToSettle = s.futureRecord[pool][owner][contractId];
        if (futureToSettle.status != Types.OrderStatus.MINTED && futureToSettle.status != Types.OrderStatus.BOUGHT) revert Errors.NotAvailableOption(pool, owner, contractId);

        int256 priceDiffInPercentage = ((TWAPOracle.getPoolTWAP(pool.token0(), pool.token1(), pool.fee(), futureToSettle.collateralAmount, true) / futureToSettle.collateralAmount) * futureToSettle.initialPrice) / futureToSettle.initialPrice;
        int256 profitInPercentage = futureToSettle.futureType == Types.FutureType.CALL ? priceDiffInPercentage : -priceDiffInPercentage;
        if (profitInPercentage < int256(futureToSettle.maintenanceMargin)) revert Errors.CollateralBelowMaintenanceMargin(priceDiffInPercentage, futureToSettle.maintenanceMargin);

        // (5% * 10_000) * (100 * 10_000) / 10_000 = 500% in basis points
        int256 realProfitPercentage = profitInPercentage * futureToSettle.leverage / Constants.BASIS_POINTS;
        // 100 * (500 * 10_000 / 100) / 10_000 = 500 in tokens
        int256 netProfit = (futureToSettle.collateralAmount * (realProfitPercentage / 100)) / Constants.BASIS_POINTS;
        // `netProfit` can be less than the collateralAmount, if the price of the pool is below the intial price
        IERC20(futureToSettle.collateralToken).transfer(msg.sender, uint256(netProfit));

        delete s.futureRecord[pool][owner][contractId];
    }
}