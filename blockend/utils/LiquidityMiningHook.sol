// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

contract LiquidityMiningHook {
    function onLiquidityMining(
        address,
        address,
        uint256,
        uint256,
        uint256
    ) external virtual returns (bool) {
        return true;
    }
}