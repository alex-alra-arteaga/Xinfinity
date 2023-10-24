// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import { Modifiers } from "../libraries/Modifiers.sol";
import { Types } from "../libraries/Types.sol";
import { Error } from "../libraries/Errors.sol";
import { UniswapV3Pool } from "../lib/v3-core/contracts/UniswapV3Pool.sol";
import { Constants } from "../libraries/Constants.sol";


contract PoolFactoryFacet is Modifiers, Constants {

    function createPool(address tokenA, address tokenB, Types.FeeType fee) external {
        if (tokenA != tokenB) revert Error.SameToken(tokenA, tokenB);
        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA); // lowest value is token0
        if (token0 == address(0)) revert Error.ZeroAddress(token0);

        int24 tickSpacing = s.feeAmountTickSpacing[fee];
        if (tickSpacing == 0) revert Error.ExistingPool(token0, token1, fee);

        uint24 fee = fee == LOW ? 500 : fee == MEDIUM ? 3000 : 10000; // value in basis points, 500 = 0.05%, 3000 = 0.3%, 10000 = 1%

        if (XSWAP_V3_FACTORY.getPool[token0][token1][fee] == address(0)) revert Error.ExistingPool(token0, token1, fee); // non existing Uniswap V3 pool
        if (s.poolRegistry[token0][token1][fee] != address(0)) revert Error.NotExistingPool(token0, token1, fee); // existing Xinfinity pool
        
        address newPool = address(new UniswapV3Pool{salt: keccak256(abi.encode(token0, token1, fee))}());
        if (newPool == address(0)) revert Error.NotExistingPool(token0, token1, fee); // failed to deploy
        
        s.poolRegistry[token0][token1][fee] = newPool;
    }
}