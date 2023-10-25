// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {IUniswapV3Factory} from "../interfaces/IUniswapV3Factory.sol";
import {INonfungiblePositionManager} from  "../interfaces/INonfungiblePositionManager.sol";

library Constants {
    IUniswapV3Factory constant XSWAP_V3_FACTORY = IUniswapV3Factory(0x1b02dA8Cb0d097eB8D57A175b88c7D8b47997506);
    address constant XUSDT_WXDC = 0x789d5d3dd968a763D20F540d085DF58223d139Fc;
    address constant XUSDT = 0xD4B5f10D61916Bd6E0860144a91Ac658dE8a1437;
    address constant WXDC = 0x951857744785E80e2De051c32EE7b25f9c458C42;
    uint8 constant XUSDT_DECIMALS = 6;
    uint8 constant WXDC_DECIMALS = 18;
    uint24 constant MIN_LEVERAGE = 10_000; // basis points 100% = 1x
    uint24 constant MAX_LEVERAGE = 400_000; // basis points 4000% = 40x
    uint256 constant PRECISION = 1e18;
    uint24 constant BASIS_POINTS = 10_000;

    INonfungiblePositionManager constant NON_FUNGIBLE_POSITION_MANAGER = INonfungiblePositionManager(0xC36442b4a4522E871399CD717aBDD847Ab11FE88);
    int24 constant LIQUIDITY_WIDTH = 10;
}
