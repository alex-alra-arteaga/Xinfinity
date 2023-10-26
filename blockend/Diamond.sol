// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {LibDiamond} from "./libraries/LibDiamond.sol";

import {Constants} from "./libraries/Constants.sol";
import {IDiamondLoupe} from "./interfaces/IDiamondLoupe.sol";
import {IDiamondCut} from "./interfaces/IDiamondCut.sol";
import {IERC165} from "./interfaces/IERC165.sol";
import {AppStorage} from "./libraries/AppStorage.sol";
import {Errors} from "./libraries/Errors.sol";
// import {UniswapV3Pool} from "./lib/v3-core/contracts/UniswapV3Pool.sol";
// import {NonfungiblePositionManager} from "./lib/v3-periphery/contracts/NonfungiblePositionManager"
// import {NonfungibleTokenPositionDescriptor} from"./lib/v3-periphery/contracts/NonfungibleTokenPositionDescriptor"

// import {ERC165} from "@openzeppelin/contracts/utils/introspection/ERC165.sol";

// See https://github.com/mudgen/diamond-2-hardhat/blob/main/contracts/Diamond.sol
// All code taken from diamond implementation, other than init code

contract Diamond {
    AppStorage internal s;

    constructor(address _protocolOwner, address _diamondCutFacet, address _xinfinityFactory, address _xinfinityNFTDescriptor, address _xinfinityManager)
    {
        LibDiamond.setProtocolOwner(_protocolOwner);
        s.admin = _protocolOwner;

        // Add the diamondCut external function from the diamondCutFacet
        IDiamondCut.FacetCut[] memory cut = new IDiamondCut.FacetCut[](1);
        bytes4[] memory functionSelectors = new bytes4[](1);
        functionSelectors[0] = IDiamondCut.diamondCut.selector;
        cut[0] = IDiamondCut.FacetCut({
            facetAddress: _diamondCutFacet,
            action: IDiamondCut.FacetCutAction.Add,
            functionSelectors: functionSelectors
        });
        LibDiamond.diamondCut(cut, address(0), "");

        LibDiamond.DiamondStorage storage ds = LibDiamond.diamondStorage();
        // adding ERC165 data
        ds.supportedInterfaces[type(IERC165).interfaceId] = true;
        ds.supportedInterfaces[type(IDiamondCut).interfaceId] = true;
        ds.supportedInterfaces[type(IDiamondLoupe).interfaceId] = true;

        // initialize the protocol AppStorage
        s.feeAmountTickSpacing[500] = 10;
        s.feeAmountTickSpacing[3000] = 60;
        s.feeAmountTickSpacing[10000] = 200;

        // here deploy factory -> Manager -> descritpion
        s.xinfinityFactory = _xinfinityFactory;
        s.xinfinityNFTDescriptor = _xinfinityNFTDescriptor;
        s.xinfinityManager = _xinfinityManager;
    }

    // Find facet for function that is called and execute the
    // function if a facet is found and return any value.
    fallback() external payable {
        LibDiamond.DiamondStorage storage ds;
        bytes32 position = LibDiamond.DIAMOND_STORAGE_POSITION;
        // get diamond storage
        assembly {
            ds.slot := position
        }

        // get facet from function selector
        address facet = address(bytes20(ds.facets[msg.sig]));
        if (facet == address(0)) revert Errors.FunctionNotFound(msg.sig);

        // Execute external function from facet using delegatecall and return any value.
        assembly {
            // copy function selector and any arguments
            calldatacopy(0, 0, calldatasize())
            // execute function call using the facet
            let result := delegatecall(gas(), facet, 0, calldatasize(), 0, 0)
            // get any return value
            returndatacopy(0, 0, returndatasize())
            // return any return value or error back to the caller
            switch result
            case 0 { revert(0, returndatasize()) }
            default { return(0, returndatasize()) }
        }
    }
}
