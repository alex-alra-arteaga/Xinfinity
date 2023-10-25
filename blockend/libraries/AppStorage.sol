// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import { Types } from "./Types.sol";

struct AppStorage {
    address admin;
    address xinfinityFactory;
    address xinfinityManager;
    address xinfinityNFTDescriptor;
    address nonfungiblePositionManager;
    /// @dev deposits[tokenId] => Deposit
    mapping(uint256 => Types.Deposit) depositsXinfinity;
    mapping(uint256 => Types.Deposit) depositXswap
;

    mapping(uint24 => int24) feeAmountTickSpacing;
    mapping(address token0 => mapping(address token1 => mapping(uint24 poolFee => address pool))) poolRegistry;
    mapping(address pool => mapping(address user => uint24 numOfRecords)) numOfRecordFutures;
    mapping(address pool => mapping(address user => uint24 numOfRecords)) numOfRecordOptions;
    mapping(address pool => mapping(address user => mapping(uint24 recordId => Types.PerpOption))) optionRecord;
    mapping(address pool => mapping(address user => mapping(uint24 recordId => Types.PerpFuture))) futureRecord;
}
