// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

library Errors {
    error CallerCanOnlyBeDiamond(address caller, address diamond);
    error SameToken(address tokenA, address tokenB);
    error ZeroAddress(address token);
    error ExistingPool(address tokenA, address tokenB, uint24 fee);
}
