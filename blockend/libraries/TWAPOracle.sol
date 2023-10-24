// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {Constants} from "./Constants.sol";
import { IDiamond } from "../interfaces/IDiamond.sol";

library TWAPOracle {
    function getPoolTWAP() internal view returns (uint256) {
        uint256 twapPrice = IDiamond(payable(address(this))).estimateWXDConXUSDT(
            1e18, 10 hours
        );
        // do we need in in usd? we could compare it with the token to xUSDT
        return twapPrice;
    }
}