// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import { Modifiers } from "../libraries/Modifiers.sol";
import { Types } from "../libraries/Types.sol";
import { Errors } from "../libraries/Errors.sol";
import {UniswapV3Pool} from "../lib/v3-core/contracts/UniswapV3Pool.sol";
import {Constants} from "../libraries/Constants.sol";


contract PoolFactory is Modifiers {

    function createPool(address tokenA, address tokenB, Types.FeeType fee) external {
        if (tokenA != tokenB) revert Errors.SameToken(tokenA, tokenB);
        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA); // lowest value is token0
        if (token0 == address(0)) revert Errors.ZeroAddress(token0);


        uint24 _fee = fee == Types.FeeType.LOW ? 500 : fee == Types.FeeType.MEDIUM ? 3000 : 10000; // value in basis points, 500 = 0.05%, 3000 = 0.3%, 10000 = 1%

        int24 tickSpacing = s.feeAmountTickSpacing[_fee];
        if (tickSpacing == 0) revert Errors.ExistingPool(token0, token1, _fee);

        if (Constants.XSWAP_V3_FACTORY.getPool(token0, token1, _fee) == address(0)) revert Errors.ExistingPool(token0, token1, _fee); // non existing Uniswap V3 pool
        if (s.poolRegistry[token0][token1][_fee] != address(0)) revert Errors.NotExistingPool(token0, token1, _fee); // existing Xinfinity pool
        
        address newPool = address(new UniswapV3Pool{salt: keccak256(abi.encode(token0, token1, _fee))}());
        if (newPool == address(0)) revert Errors.NotExistingPool(token0, token1, _fee); // failed to deploy

        s.poolRegistry[token0][token1][_fee] = newPool;
    }
}