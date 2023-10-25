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
    error NotIncludedInPool(address token, address token0, address token1);
    error OnlyDelegateCalls(address caller, address delegate);
    error NotAvaibleFuture(address pool, address owner, uint256 contractId);
    error NotAvailableOption(address pool, address owner, uint256 contractId);
    error CollateralBelowMaintenanceMargin(uint256 collateral, uint256 maintenanceMargin);
    error NoProfit();
    error CannotBuyFromYourself(address owner);
    error NotLiquidable();
    error PositionsIsLiquidable();
    error IncorrectLeverage();
    error TransferFailed();
    error FunctionNotFound(bytes4 selector);
}
