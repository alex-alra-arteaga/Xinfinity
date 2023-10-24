// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {Modifiers} from "../libraries/Modifiers.sol";

/// @dev Used to view data from the AppStorage
contract ViewFacet is Modifiers {

    function positionHealthFactor() external view returns (uint256) {
        
    }
}