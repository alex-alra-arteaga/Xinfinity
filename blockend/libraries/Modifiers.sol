// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {AppStorage} from "./AppStorage.sol";
import {Errors} from "./Errors.sol";

contract Modifiers {
    AppStorage internal s;

    address _self;

    constructor () {
        _self = address(this);
    }

    modifier onlyDiamond() {
        if (
            msg.sender != address(this))
            revert Errors.CallerCanOnlyBeDiamond(msg.sender, address(this));
        _;
    }

    modifier onlyDelegateCall() {
        if (msg.sender != _self)
            revert Errors.OnlyDelegateCalls(msg.sender, _self);
        _;
    }

}