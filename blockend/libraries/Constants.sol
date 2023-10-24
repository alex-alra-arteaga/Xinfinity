// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {IUniswapV3Factory} from "../lib/v3-core/contracts/interfaces/IUniswapV3Factory.sol";

library Constants {
    IUniswapV3Factory constant XSWAP_V3_FACTORY = IUniswapV3Factory(0x1b02dA8Cb0d097eB8D57A175b88c7D8b47997506);
    address constant XUSDT_WXDC = 0x789d5d3dd968a763D20F540d085DF58223d139Fc;
    address constant XUSDT = 0xD4B5f10D61916Bd6E0860144a91Ac658dE8a1437;
    address constant WXDC = 0x951857744785E80e2De051c32EE7b25f9c458C42;
    uint8 constant XUSDT_DECIMALS = 6;
    uint8 constant WXDC_DECIMALS = 18;
}