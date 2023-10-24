// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;


library Types {
    enum FeeType {
        LOW,
        MEDIUM,
        HIGH
    }

    enum OptionType {
        CALL,
        PUT
    }
}