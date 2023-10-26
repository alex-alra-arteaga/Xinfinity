// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity 0.8.19;

import './libraries/SafeERC20Namer.sol';

import './libraries/ChainId.sol';
import './interfaces/INonfungiblePositionManager.sol';
import './interfaces/INonfungibleTokenPositionDescriptor.sol';
import './interfaces/IERC20Metadata.sol';
import './libraries/PoolAddress.sol';
import './libraries/TokenRatioSortOrder.sol';

/// @title Describes NFT token positions
/// @notice Produces a string containing the data URI for a JSON metadata string
contract NonfungibleTokenPositionDescriptor is INonfungibleTokenPositionDescriptor {
    address private constant XUSDT = 0xD4B5f10D61916Bd6E0860144a91Ac658dE8a1437;

    address public immutable WXDC;
    /// @dev A null-terminated string
    bytes32 public immutable nativeCurrencyLabelBytes;

    constructor(address _WXDC, bytes32 _nativeCurrencyLabelBytes) {
        WXDC = _WXDC;
        nativeCurrencyLabelBytes = _nativeCurrencyLabelBytes;
    }

    /// @notice Returns the native currency label as a string
    function nativeCurrencyLabel() public view returns (string memory) {
        uint256 len = 0;
        while (len < 32 && nativeCurrencyLabelBytes[len] != 0) {
            len++;
        }
        bytes memory b = new bytes(len);
        for (uint256 i = 0; i < len; i++) {
            b[i] = nativeCurrencyLabelBytes[i];
        }
        return string(b);
    }

    function flipRatio(
        address token0,
        address token1,
        uint256 chainId
    ) public view returns (bool) {
        return tokenRatioPriority(token0, chainId) > tokenRatioPriority(token1, chainId);
    }

    function tokenRatioPriority(address token, uint256 chainId) public view returns (int256) {
        if (token == WXDC) {
            return TokenRatioSortOrder.DENOMINATOR;
        }
        if (chainId == 51) {
            if (token == XUSDT) {
                return TokenRatioSortOrder.NUMERATOR_MOST;
            } else {
                return 0;
            }
        }
        return 0;
    }
}
