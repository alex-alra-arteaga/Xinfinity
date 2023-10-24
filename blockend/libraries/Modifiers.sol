// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {AppStorage} from "./AppStorage.sol";
import {Errors} from "./Errors.sol";

contract Modifiers {
    AppStorage internal s;

    modifier onlyDiamond() {
        if (
            msg.sender != address(this))
            revert Errors.CallerCanOnlyBeDiamond(msg.sender, address(this));
        _;
    }
}