// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {Test} from "../lib/forge-std/src/Test.sol";
import {IDiamond} from "../interfaces/IDiamond.sol";
import {DiamondCutFacet} from "../facets/DiamondCutFacet.sol";
import {Diamond} from "../Diamond.sol";
import {DiamondLoupeFacet} from "../facets/DiamondLoupeFacet.sol";
import {ViewFacet} from "../facets/ViewFacet.sol";
import {console} from "../lib/forge-std/src/console.sol";
contract DeployProtocol is Test {
}
/*

    // DiamondLogic contracts
    //IDiamond public diamond;
    address public _diamond;
    address public _diamondLoupe;
    address public _diamondCut;

    // Core protocol logic contracts
    address public leverageFacet;
    address public liquidatorFacet;
    address public perpFuturesFacet;
    address public perpOptionsFacet;
    address public poolControllerFacet;
    address public twapFacet;
    address public xinfinityLPManagaerFacet;
    address public viewFacet;

    // Function Selectors of each contract
    bytes4[] internal diamondSelectors;
    bytes4[] internal loupeSelectors;
    bytes4[] internal cutSelectors;
    bytes4[] internal leverageSelectors;
    bytes4[] internal liquidatorSelectors;
    bytes4[] internal perpFuturesSelectors;
    bytes4[] internal perpOptionsSelectors;
    bytes4[] internal poolControllerSelectors;
    bytes4[] internal twapSelectors;
    bytes4[] internal xinfinityLPManagaerSelectors;
    bytes4[] internal viewSelectors;

    function getSelector(string memory _func) internal pure returns (bytes4) {
        return bytes4(keccak256(bytes(_func)));
    }

    function run() external {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        address owner = vm.addr(privateKey);

        console.log("Deploying contracts, with address: ", owner);

        vm.startBroadcast(privateKey); // pass the input key

        // Selectors per contract
        loupeSelectors = [
            IDiamond.facets.selector,
            IDiamond.facetFunctionSelectors.selector,
            IDiamond.facetAddresses.selector,
            IDiamond.facetAddress.selector
        ];

        viewSelectors = [
            IDiamond.positionHealthFactorFutures.selector
        ];

        _diamondCut = address(new DiamondCutFacet());
        _diamond = address(new Diamond(0x5b73C5498c1E3b4dbA84de0F1833c4a029d90519, _diamondCut)); // precalculated address added
        _diamondLoupe = address(new DiamondLoupeFacet());
        viewFacet = address(new ViewFacet());

        vm.stopBroadcast();

        IDiamond.FacetCut[] memory cut;

        cut = new IDiamond.FacetCut[](7);

        cut[0] = (
            IDiamond.FacetCut({
                facetAddress: _diamondLoupe,
                action: IDiamond.FacetCutAction.Add,
                functionSelectors: loupeSelectors
            })
        );

        cut[1] = (
            IDiamond.FacetCut({
                facetAddress: viewFacet,
                action: IDiamond.FacetCutAction.Add,
                functionSelectors: viewSelectors
            })
        );

        assertNotEq(_diamond, address(0));
        assertNotEq(_diamondLoupe, address(0));
        assertNotEq(_diamondCut, address(0));
        assertNotEq(viewFacet, address(0));

        IDiamond diamond = IDiamond(payable(_diamond));
        diamond.diamondCut(cut, address(0x0), "");

        IDiamond.Facet[] memory facets = diamond.facets();
        
        // @dev first facet is DiamondCutFacet
        assertEq(facets.length, cut.length + 1);
        for (uint256 i = 0; i < facets.length - 1; i++) {
            assertNotEq(facets[i].facetAddress, address(0));
            assertEq(
                facets[i + 1].functionSelectors.length, cut[i].functionSelectors.length
            );
            for (uint256 y = 0; y < facets[i + 1].functionSelectors.length; y++) {
                assertEq(facets[i + 1].functionSelectors[y], cut[i].functionSelectors[y]);
            }
        }
        console.log("Diamond deployed with address: ", _diamond);
        console.log("DiamondCutFacet deployed with address: ", _diamondCut);
        console.log("DiamondLoupeFacet deployed with address: ", _diamondLoupe);
    }
}
*/