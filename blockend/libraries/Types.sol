// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

library Types {
    enum FeeType {
        LOW,
        MEDIUM,
        HIGH
    }

    enum FutureType {
        CALL,
        PUT
    }

    enum OptionType {
        CALL,
        PUT
    }

    enum PerpType {
        FUTURE,
        OPTION
    }

    enum OrderStatus {
        UNINITIALIZED,
        MINTED,
        BOUGHT,
        EXERCISED,
        CANCELLED
    }

    struct FutureParams {
        uint256 amount;
        address token;
        address pool;
        uint24 poolFee;
        uint24 leverage;
        Types.FutureType futureType;
    }

    struct OptionParams { 
        uint256 amount;
        uint256 strike;
        address token;
        address pool;
        uint24 poolFee;
        uint24 leverage;
        address token0;
        address token1;
        Types.OptionType optionType;
    }

    struct Deposit {
        address owner;
        uint128 liquidity;
        address token0;
        address token1;
    }

    struct PerpFuture {
        FutureType futureType; // call or put
        address xinfinityPool;
        uint256 initialPrice; // of the pool
        uint256 leverage; // equals margin in finance terms, in basis points
        uint256 collateralAmount; // amount set in collateral
        int256 fundingRatePayment; // extra tokens to pay to seller/buyer depending on funding rate
        address collateralToken; // token used as collateral
        uint256 borrowAmount; // amount borrowed from the pool
        uint256 maintenanceMargin; // % of collateral that must be maintained over borrowAmount, in basis points
        OrderStatus status;
    }

    struct PerpOption {
        OptionType optionType; // call or put
        address xinfinityPool; // pool address of the protocol, on top of xSwap pool
        uint256 initialPrice; // of the pool
        uint256 leverage; // borrowAmount / collateralAmount, in basis points
        uint256 strike; // strike price of the option
        uint256 collateralAmount; // amount set in collateral
        int256 fundingRatePayment; // extra tokens to pay to seller/buyer depending on funding rate
        address collateralToken; // token used as collateral
        uint256 borrowAmount; // amount borrowed from the pool
        uint256 premium; // amount of premium paid to the pool to cover LP risk
        OrderStatus status;
    }
}
