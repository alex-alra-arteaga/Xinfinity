// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import { Modifiers } from "../libraries/Modifiers.sol";
import { Errors } from "../libraries/Errors.sol";
import { Types } from "../libraries/Types.sol";
import { TWAPOracle } from "../libraries/TWAPOracle.sol";
import { IERC20 } from "../@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract PerpOptionsFacet is Modifiers {
    using TWAPOracle for address;

    function buyOptionContract(uint256 contractId, address pool, address token) external {

    }

    /**
     * @notice Mints an option contract
     * @dev Make sure to approve the correct amount of tokens + premium before calling this function
     * @param amount Number of tokens to lock as collateral
     * @param strike Price at which the option is ITM (in the money)
     * @param token Token of pool to lock as collateral
     * @param pool Pool you are buying the option from
     * @param leverage Amount of leverage you want to use in basis points (10000 = 100%)
     */
    function sellOptionContract(uint256 amount, uint256 strike, address token, address pool, uint24 poolFee, uint8 leverage, Types.OptionType optionType) external returns (uint256 recordId) {
        // CHECKS
        address token0 = pool.token0();
        address token1 = pool.token1();
        if (s.poolRegistry[token0][token1][poolFee] != pool) revert Errors.NotSupportedPool();

        uint256 userBalance = IERC20(token).balanceOf(msg.sender); // no reentrancy possible since code is at the top
        if (amount > userBalance) revert Errors.InsufficientBalance(amount, userBalance);

        uint256 amountCost = getPoolTWAP(token0, token1, poolFee, amount);
        uint256 price = amountCost / amount;
        if (optionType == Types.OptionType.PUT) {
            if (strike > price) revert Errors.IncorrectStrike(price, strike);
        } else {
            if (strike < price) revert Errors.IncorrectStrike(price, strike);
        }

        if (leverage > Constants.MAX_LEVERAGE || leverage < Constants.MIN_LEVERAGE) revert Errors.IncorrectLeverage(leverage);

        if (token != token0 || token != token1) revert Errors.NotIncludedInPool(token, token0, token1);
        // EFFECTS
        // transferFrom token to Diamond
        uint256 premium = ((amount * leverage) / poolFee) / 10_000;

        IERC20(token).transferFrom(msg.sender, pool, amount + premium);

        // INTERACTIONS
        // update AppStorage position
        unchecked {
            recordId = s.numOfRecordOptions[pool][msg.sender]++;
        }
        Types.PerpOption storage option = s.optionRecord[pool][msg.sender][recordId];
        option.optionType = optionType;
        option.xinfinityPool = pool;
        option.initialPrice = price;
        option.leverage = leverage;
        option.strike = strike;
        option.collateralAmount = amount;
        option.borrowAmount = (amount * leverage) / 10_000;
        option.maintenanceMargin = 100 * Constants.PRECISION / (leverage / (10_000 * Constants.PRECISION));
        option.premium = premium;
    }

    function closeOptionContract() external {

    }
}