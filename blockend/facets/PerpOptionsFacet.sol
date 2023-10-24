// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import { Modifiers } from "../libraries/Modifiers.sol";
import { Errors } from "../libraries/Errors.sol";
import { Types } from "../libraries/Types.sol";
import { TWAPOracle } from "../libraries/TWAPOracle.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract PerpOptionsFacet is Modifiers {
    using TWAPOracle for address;

    function buyOptionContract(uint256 contractId, address pool, address token) external {

    }

    /**
     * 
     * @param amount Number of tokens to lock as collateral
     * @param strike Price at which the option is ITM (in the money)
     * @param token Token of pool to lock as collateral
     * @param pool Pool you are buying the option from
     * @param leverage Amount of leverage you want to use
     */
    function sellOptionContract(uint256 amount, uint256 strike, address token, address pool, uint24 poolFee, uint256 leverage, Types.OptionType optionType) external {
        // CHECKS
        if (s.poolRegistry[pool.token0()][pool.token1()][poolFee] != pool) revert Errors.NotSupportedPool();
        uint256 userBalance = IERC20(token).balanceOf(msg.sender); // no reentrancy possible since code is at the top
        if (amount > userBalance) revert Errors.InsufficientBalance(amount, userBalance);
        if (optionType == Types.OptionType.CALL) {
            if (strike > getPoolTWAP) revert Errors.InsufficientBalance(amount, userBalance);
        } else {
            if (strike < getPoolTWAP()) revert Errors.InsufficientBalance(amount, userBalance);
        }
        // EFFECTS
        // transferFrom token to Diamond

        // INTERACTIONS
        // update AppStorage position

        // mint position 
    }

    function closeOptionContract() external {

    }
}