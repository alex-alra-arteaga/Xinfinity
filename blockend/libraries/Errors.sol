// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

library Errors {
    error CallerCanOnlyBeDiamond(address caller, address diamond);
    error SameToken(address tokenA, address tokenB);
    error ZeroAddress(address token);
    error ExistingPool(address tokenA, address tokenB, uint24 fee);
    error NotExistingPool(address tokenA, address tokenB, uint24 fee);
    error IncorrectStrike(uint256 spotPrice, uint256 strike);
    error InsufficientBalance(uint256 amount, uint256 balance);
    error NotSupportedPool();
    error IncorrectLeverage(uint256 leverage);
    error NotIncludedInPool(address token, address token0, address token1);
}
