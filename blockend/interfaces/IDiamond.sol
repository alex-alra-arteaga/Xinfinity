// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

interface IDiamond {
    function estimateWXDConXUSDT(uint128 amountIn, uint32 secondsAgo) external view returns (uint256 amountOut);
}