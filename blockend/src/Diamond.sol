// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {LibDiamond} from "../libraries/LibDiamond.sol";
import {IDiamondLoupe} from "../interfaces/IDiamondLoupe.sol";
import {IDiamondCut} from "../interfaces/IDiamondCut.sol";
import {IERC165} from "@openzeppelin/contracts/utils/introspection/IERC165.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import { IERC4626 } from "@openzeppelin/contracts/interfaces/IERC4626.sol";
import {AppStorage} from "../libraries/AppStorage.sol";
import {Errors} from "../libraries/Errors.sol";
// import {ERC165} from "@openzeppelin/contracts/utils/introspection/ERC165.sol";

// See https://github.com/mudgen/diamond-2-hardhat/blob/main/contracts/Diamond.sol
// All code taken from diamond implementation, other than init code

contract Diamond is ISubscriptionOwner {
    AppStorage internal s;

    constructor(address _protocolOwner, address _diamondCutFacet)
        payable
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

    }

    function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4) {
        // ERC721 callback
        return bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"));
    }

    function getSubscriptionOwner() external view returns (address) {
        // the owner of the subscription must be an EOA
        // Replace this with the account created in Step 1
        return s.admin;
    }

    function supportsInterface(bytes4 interfaceId) public view  returns (bool) {
        return interfaceId == type(ISubscriptionOwner).interfaceId;
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

    receive() external payable {
        revert("Diamond: Does not accept ether");
    }

}
