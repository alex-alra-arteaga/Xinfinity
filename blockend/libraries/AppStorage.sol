// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import { Types } from "./Types.sol";

struct AppStorage {
    address admin;

    mapping(address token0 => mapping(address token1 => mapping(uint24 poolFee => address pool))) poolRegistry;
    mapping(uint24 => int24) feeAmountTickSpacing;

}