// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import { Modifiers } from "../libraries/Modifiers.sol";
import { Errors } from "../libraries/Errors.sol";
import { Types } from "../libraries/Types.sol";
import { TWAPOracle } from "../libraries/TWAPOracle.sol";
import { IERC20 } from "../interfaces/IERC20.sol";
import { IUniswapV3Pool } from "../interfaces/IUniswapV3Pool.sol";
import {Constants} from "../libraries/Constants.sol";
import {IDiamond} from "../interfaces/IDiamond.sol";
import {IUniswapV3Pool} from "../interfaces/IUniswapV3Pool.sol";

contract PerpOptionsFacet is Modifiers {
    using TWAPOracle for address;

    /**
     * 
     * @param pool Pool you are buying the option from
     * @param owner Owner of the option
     * @param contractId Id of the option
     */
    function buyOptionContract(address pool, address owner, uint24 contractId) external {
        if (msg.sender == owner) revert Errors.CannotBuyFromYourself(owner);
        Types.PerpOption memory optionToBuy = s.optionRecord[pool][owner][contractId];
        if (optionToBuy.status != Types.OrderStatus.MINTED) revert Errors.NotAvailableOption(pool, owner, contractId);

        IERC20(optionToBuy.collateralToken).transferFrom(msg.sender, address(this), optionToBuy.premium);
        IERC20(optionToBuy.collateralToken).transferFrom(msg.sender, owner, uint256(int256(optionToBuy.collateralAmount) + optionToBuy.fundingRatePayment));

        optionToBuy.status = Types.OrderStatus.BOUGHT;
        s.optionRecord[pool][msg.sender][contractId] = optionToBuy;
        delete s.optionRecord[pool][owner][contractId];
    }

    /**
     * @notice Mints an option contract
     * @dev Make sure to approve the correct amount of tokens + premium before calling this function
     * @param amount Number of tokens to lock as collateral
     * @param strike Price at which the option is ITM (in the money)
     * @param token Token of pool to lock as collateral
     * @param pool Pool you are minting the option from
     * @param leverage Amount of leverage you want to use in basis points (10000 = 100%)
     */
    function sellOptionContract(uint256 amount, uint256 strike, address token, address pool, uint24 poolFee, uint24 leverage, Types.OptionType optionType) external onlyDiamond returns (uint24 recordId) {
        // CHECKS
        address token0 = IUniswapV3Pool(pool).token0();
        address token1 = IUniswapV3Pool(pool).token1();
        if (s.poolRegistry[token0][token1][poolFee] != pool) revert Errors.NotSupportedPool();

        uint256 amountCost = TWAPOracle.getPoolTWAP(token0, token1, poolFee, uint128(amount), true);
        uint256 price = amountCost / amount;
        if (optionType == Types.OptionType.PUT) {
            if (strike > price) revert Errors.IncorrectStrike(price, strike);
        } else {
            if (strike < price) revert Errors.IncorrectStrike(price, strike);
        }

        if (leverage > Constants.MAX_LEVERAGE || leverage < Constants.MIN_LEVERAGE) revert Errors.IncorrectLeverage();

        if (token != token0 || token != token1) revert Errors.NotIncludedInPool(token, token0, token1);

        // EFFECTS
        uint256 premium = ((amount * leverage) / poolFee) / Constants.BASIS_POINTS;
        uint256 priceRatio = TWAPOracle.getRatioXinfinityXSwapPool(token0, token1, poolFee, uint128(amount));
        // ((1.01 * 10_000 * 100) / 10_000) - 100 = 1 token  (if xSwap pool price is 1% higher than Xinfinity pool, shorters will pay 1 token more to longers, to raise the price of the pool)
        // ((0.99 * 10_000 * 100) / 10_000) - 100 = -1 token  (if xSwap pool price is 1% lower than Xinfinity pool, shorters will receive 1 token more from longers, to lower the price of the pool)
        int256 fundingRate = int256(((priceRatio * amount) / Constants.BASIS_POINTS) - amount);
        int256 fundingRatePayment = optionType == Types.OptionType.CALL ? fundingRate : -fundingRate;
        /// @dev due to onlyDiamond modifier, address(this) is the Diamond contract, so PoolController will be able to move the tokens
        IERC20(token).transferFrom(msg.sender, address(this), uint256(int256(amount) + int256(premium) + fundingRatePayment));

        uint256 borrowAmount =  (amount * leverage) / Constants.BASIS_POINTS;

        (,int24 currentTick,,,,,) = IUniswapV3Pool(pool).slot0();
        
        // call PoolController to move liquidity
        IDiamond(address(this)).mintNewPosXinfin(token == token0 ? borrowAmount : 0, token == token1 ? borrowAmount : 0, currentTick, poolFee, token0, token1); 

        // INTERACTIONS
        // update AppStorage position
        unchecked {
            recordId = s.numOfRecordOptions[pool][msg.sender]++;
        }
        Types.PerpOption storage option = s.optionRecord[pool][msg.sender][recordId];
        if (option.status != Types.OrderStatus.UNINITIALIZED) revert Errors.NotAvailableOption(pool, msg.sender, recordId);
        option.optionType = optionType;
        option.xinfinityPool = pool;
        option.initialPrice = price;
        option.leverage = leverage;
        option.strike = strike;
        option.collateralAmount = amount;
        option.fundingRatePayment = fundingRatePayment;
        option.borrowAmount = (amount * leverage) / Constants.BASIS_POINTS;
        option.premium = premium;
        option.status = Types.OrderStatus.MINTED;
    }

    /**
     * @notice callable by shorters and longers
     * @param pool Pool you are minting the option from
     * @param owner Owner of the option
     * @param contractId Id of the option
     */
    function exerciseOptionContract(IUniswapV3Pool pool, address owner, uint24 contractId) external {
        Types.PerpOption memory optionToExercise = s.optionRecord[address(pool)][owner][contractId];
        if (optionToExercise.status != Types.OrderStatus.MINTED && optionToExercise.status != Types.OrderStatus.BOUGHT) revert Errors.NotAvailableOption(address(pool), owner, contractId);

        // (actual price * initialPrice) / initialPrice, result in basis points
        int256 priceDiffInPercentage = int256(((TWAPOracle.getPoolTWAP(pool.token0(), pool.token1(), pool.fee(), uint128(optionToExercise.collateralAmount), true) / optionToExercise.collateralAmount) * optionToExercise.initialPrice) / optionToExercise.initialPrice);
        int256 profitInPercentage = optionToExercise.optionType == Types.OptionType.CALL ? priceDiffInPercentage : -priceDiffInPercentage;

        // (5% * 10_000) * (100 * 10_000) / 10_000 = 500% in basis points
        int256 realProfitPercentage = profitInPercentage * int256(optionToExercise.leverage) / int24(Constants.BASIS_POINTS);
        // 100 * (500 * 10_000 / 100) / 10_000 = 500 in tokens
        int256 netProfit = (int256(optionToExercise.collateralAmount) * (realProfitPercentage / 100)) / int24(Constants.BASIS_POINTS);

        bool inTheMoney = netProfit > 0;
        if (inTheMoney) {
            // @follow-up Take tokens from the pool to pay the profit
            IERC20(optionToExercise.collateralToken).transfer(msg.sender, uint256(netProfit));
        } else { // OTM (out of the money)
            // because the option is OTM, the collateral is returned to the owner
            IERC20(optionToExercise.collateralToken).transfer(msg.sender, uint256(optionToExercise.collateralAmount));
        }

        delete s.optionRecord[address(pool)][owner][contractId];
    }
}