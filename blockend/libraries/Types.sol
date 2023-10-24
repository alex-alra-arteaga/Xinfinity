// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

library Types {
    enum FeeType {
        LOW,
        MEDIUM,
        HIGH
    }

    enum OptionType {
        CALL,
        PUT
    }

    struct PerpFuture {
        address xinfinityPool;
        uint256 initialPrice; // of the pool
        uint256 leverage; // equals margin in finance terms, in basis points
        uint256 strike;
        uint256 collateralAmount; // amount set in collateral
        uint256 borrowAmount; // amount borrowed from the pool
    }

    struct PerpOption {
        Types.OptionType optionType; // call or put
        address xinfinityPool; // pool address of the protocol, on top of xSwap pool
        uint256 initialPrice; // of the pool
        uint256 leverage; // borrowAmount / collateralAmount, in basis points
        uint256 strike; // strike price of the option
        uint256 collateralAmount; // amount set in collateral
        uint256 borrowAmount; // amount borrowed from the pool
        uint256 maintenanceMargin; // % of collateral that must be maintained over borrowAmount, in basis points
        uint256 premium; // amount of premium paid to the pool to cover LP risk
    }
}