// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {Modifiers} from "../libraries/Modifiers.sol";
import {Errors} from "../libraries/Errors.sol";
import {Types} from "../libraries/Types.sol";
import {TWAPOracle} from "../libraries/TWAPOracle.sol";
import {IERC20} from "../interfaces/IERC20.sol";
import {IUniswapV3Pool} from "../interfaces/IUniswapV3Pool.sol";
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
    function buyOptionContract(
        address pool,
        address owner,
        uint24 contractId
    ) external {
        if (msg.sender == owner) revert Errors.CannotBuyFromYourself(owner);
        Types.PerpOption memory optionToBuy = s.optionRecord[pool][owner][
            contractId
        ];
        if (optionToBuy.status != Types.OrderStatus.MINTED)
            revert Errors.NotAvailableOption(pool, owner, contractId);

        IERC20(optionToBuy.collateralToken).transferFrom(
            msg.sender,
            address(this),
            optionToBuy.premium
        );
        IERC20(optionToBuy.collateralToken).transferFrom(
            msg.sender,
            owner,
            uint256(
                int256(optionToBuy.collateralAmount) +
                    optionToBuy.fundingRatePayment
            )
        );

        optionToBuy.status = Types.OrderStatus.BOUGHT;
        s.optionRecord[pool][msg.sender][contractId] = optionToBuy;
        delete s.optionRecord[pool][owner][contractId];
    }

    /**
     * @notice Mints an option contract
     * @dev Make sure to approve the correct amount of tokens + premium before calling this function
     * param amount Number of tokens to lock as collateral
     * param strike Price at which the option is ITM (in the money)
     * param token Token of pool to lock as collateral
     * param pool Pool you are minting the option from
     * param leverage Amount of leverage you want to use in basis points (10000 = 100%)
     */
    function sellOptionContract(
        Types.OptionParams memory param
    ) external onlyDiamond returns (uint24 recordId) {
        // CHECKS
        (
            uint256 price,
            uint256 premium,
            address token0,
            address token1
        ) = _preSellOptionValidations(param);
        param.token0 = token0;
        param.token1 = token1;

        // EFFECTS
        (int256 fundingRatePayment, uint256 borrowAmount) = _processOptionSell(
            param
        );

        // INTERACTIONS
        recordId = _updateOptionRecord(
            param,
            price,
            fundingRatePayment,
            borrowAmount,
            premium
        );
    }

    function _preSellOptionValidations(
        Types.OptionParams memory param
    ) internal view returns (uint256, uint256, address, address) {
        _setPoolTokens(param);
        _validatePoolRegistry(param);
        uint256 price = _calculatePrice(param);
        _validateStrikePrice(param, price);
        _validateLeverage(param);

        uint256 premium = _calculatePremium(param);

        return (price, premium, param.token0, param.token1);
    }

    function _setPoolTokens(Types.OptionParams memory param) internal view {
        param.token0 = IUniswapV3Pool(param.pool).token0();
        param.token1 = IUniswapV3Pool(param.pool).token1();
    }

    function _validatePoolRegistry(
        Types.OptionParams memory param
    ) internal view {
        if (
            s.poolRegistry[param.token0][param.token1][param.poolFee] !=
            param.pool
        ) revert Errors.NotSupportedPool();
    }

    function _calculatePrice(
        Types.OptionParams memory param
    ) internal view returns (uint256) {
        uint256 amountCost = TWAPOracle.getPoolTWAP(
            param.token0,
            param.token1,
            param.poolFee,
            uint128(param.amount),
            true
        );
        return amountCost / param.amount;
    }

    function _validateStrikePrice(
        Types.OptionParams memory param,
        uint256 price
    ) internal pure {
        if (param.optionType == Types.OptionType.PUT) {
            if (param.strike > price)
                revert Errors.IncorrectStrike(price, param.strike);
        } else {
            if (param.strike < price)
                revert Errors.IncorrectStrike(price, param.strike);
        }
    }

    function _validateLeverage(Types.OptionParams memory param) internal pure {
        if (
            param.leverage > Constants.MAX_LEVERAGE ||
            param.leverage < Constants.MIN_LEVERAGE
        ) revert Errors.IncorrectLeverage();
    }

    function _calculatePremium(
        Types.OptionParams memory param
    ) internal pure returns (uint256) {
        return
            ((param.amount * param.leverage) / param.poolFee) /
            Constants.BASIS_POINTS;
    }

    function _processOptionSell(
        Types.OptionParams memory param
    ) internal returns (int256, uint256) {
        // Calculate fundingRatePayment
        int256 fundingRatePayment = _calculateFundingRatePayment(param);

        // Calculate borrowAmount
        uint256 borrowAmount = _calculateBorrowAmount(param);

        // Interact with external contracts
        (, int24 currentTick, , , , , ) = IUniswapV3Pool(param.pool).slot0();
        IDiamond(address(this)).mintNewPosXinfin(
            param.token == param.token0 ? borrowAmount : 0,
            param.token == param.token1 ? borrowAmount : 0,
            currentTick,
            param.poolFee,
            param.token0,
            param.token1
        );

        return (fundingRatePayment, borrowAmount);
    }

    function _calculateFundingRatePayment(
        Types.OptionParams memory param
    ) internal returns (int256) {
        uint256 priceRatio = TWAPOracle.getRatioXinfinityXSwapPool(
            param.token0,
            param.token1,
            param.poolFee,
            uint128(param.amount)
        );
        int256 fundingRate = int256(
            ((priceRatio * param.amount) / Constants.BASIS_POINTS) -
                param.amount
        );
        int256 fundingRatePayment = param.optionType == Types.OptionType.CALL
            ? fundingRate
            : -fundingRate;
        IERC20(param.token).transferFrom(
            msg.sender,
            address(this),
            uint256(int256(param.amount) + fundingRatePayment)
        );
        return fundingRatePayment;
    }

    function _calculateBorrowAmount(
        Types.OptionParams memory param
    ) internal pure returns (uint256) {
        uint256 borrowAmount = (param.amount * param.leverage) /
            Constants.BASIS_POINTS;
        return borrowAmount;
    }

    function _updateOptionRecord(
        Types.OptionParams memory param,
        uint256 price,
        int256 fundingRatePayment,
        uint256 borrowAmount,
        uint256 premium
    ) internal returns (uint24 recordId) {
        // INTERACTIONS
        // update AppStorage position
        unchecked {
            recordId = s.numOfRecordOptions[param.pool][msg.sender]++;
        }
        Types.PerpOption storage option = s.optionRecord[param.pool][
            msg.sender
        ][recordId];
        if (option.status != Types.OrderStatus.UNINITIALIZED)
            revert Errors.NotAvailableOption(param.pool, msg.sender, recordId);
        option.optionType = param.optionType;
        option.xinfinityPool = param.pool;
        option.initialPrice = price;
        option.leverage = param.leverage;
        option.strike = param.strike;
        option.collateralAmount = param.amount;
        option.fundingRatePayment = fundingRatePayment;
        option.borrowAmount = borrowAmount;
        option.premium = premium;
        option.status = Types.OrderStatus.MINTED;
    }

    /**
     * @notice callable by shorters and longers
     * @param pool Pool you are minting the option from
     * @param owner Owner of the option
     * @param contractId Id of the option
     */
    function exerciseOptionContract(
        IUniswapV3Pool pool,
        address owner,
        uint24 contractId
    ) external {
        Types.PerpOption memory optionToExercise = getOptionToExercise(
            pool,
            owner,
            contractId
        );
        (
            int24 currentTick,
            int256 netProfit,
            bool inTheMoney
        ) = calculateProfits(optionToExercise, pool);
        executeOption(
            pool,
            optionToExercise,
            netProfit,
            inTheMoney,
            currentTick,
            contractId
        );
    }

    function getOptionToExercise(
        IUniswapV3Pool pool,
        address owner,
        uint24 contractId
    ) internal view returns (Types.PerpOption memory) {
        Types.PerpOption memory optionToExercise = s.optionRecord[
            address(pool)
        ][owner][contractId];
        if (
            optionToExercise.status != Types.OrderStatus.MINTED &&
            optionToExercise.status != Types.OrderStatus.BOUGHT
        ) revert Errors.NotAvailableOption(address(pool), owner, contractId);
        return optionToExercise;
    }

    function calculateProfits(
        Types.PerpOption memory optionToExercise,
        IUniswapV3Pool pool
    )
        internal
        view
        returns (int24 currentTick, int256 netProfit, bool inTheMoney)
    {
        int256 priceDiffInPercentage = int256(
            ((TWAPOracle.getPoolTWAP(
                pool.token0(),
                pool.token1(),
                pool.fee(),
                uint128(optionToExercise.collateralAmount),
                true
            ) / optionToExercise.collateralAmount) *
                optionToExercise.initialPrice) / optionToExercise.initialPrice
        );
        // ... your price calculation logic ...
        int256 profitInPercentage = optionToExercise.optionType ==
            Types.OptionType.CALL
            ? priceDiffInPercentage
            : -priceDiffInPercentage;

        int256 realProfitPercentage = (profitInPercentage *
            int256(optionToExercise.leverage)) / int24(Constants.BASIS_POINTS);

        netProfit =
            (int256(optionToExercise.collateralAmount) *
                (realProfitPercentage / 100)) /
            int24(Constants.BASIS_POINTS);

        (, currentTick, , , , , ) = IUniswapV3Pool(pool).slot0();
        inTheMoney = netProfit > 0;
    }

    function executeOption(
        IUniswapV3Pool pool,
        Types.PerpOption memory optionToExercise,
        int256 netProfit,
        bool inTheMoney,
        int24 currentTick,
        uint24 contractId
    ) internal {
        if (inTheMoney) {
            IDiamond(address(this)).mintNewPosXinfin(
                optionToExercise.collateralToken == pool.token0()
                    ? uint256(int256(netProfit))
                    : 0,
                optionToExercise.collateralToken == pool.token1()
                    ? uint256(int256(netProfit))
                    : 0,
                currentTick,
                pool.fee(),
                pool.token0(),
                pool.token1()
            );
            IERC20(optionToExercise.collateralToken).transfer(
                msg.sender,
                uint256(netProfit)
            );
        } else {
            IERC20(optionToExercise.collateralToken).transfer(
                msg.sender,
                uint256(optionToExercise.collateralAmount)
            );
        }
        delete s.optionRecord[address(pool)][msg.sender][contractId];
    }
}
