// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import { Types } from "./Types.sol";

struct AppStorage {
    address admin;

    mapping(address => mapping(address => mapping(uint24 => address))) poolRegistry;
    mapping(uint24 => int24) feeAmountTickSpacing;

}
