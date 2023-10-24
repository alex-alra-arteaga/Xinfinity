// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

library Errors {
    error CallerCanOnlyBeDiamond(address caller, address diamond);
}
