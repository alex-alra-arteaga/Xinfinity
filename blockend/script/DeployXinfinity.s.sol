// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {Test} from "../lib/forge-std/src/Test.sol";
import {IDiamond} from "../interfaces/IDiamond.sol";
import {DiamondCutFacet} from "../facets/DiamondCutFacet.sol";
import {Diamond} from "../Diamond.sol";
import {DiamondLoupeFacet} from "../facets/DiamondLoupeFacet.sol";
import {LeverageFacet} from "../facets/LeverageFacet.sol";
import {LiquidatorFacet} from "../facets/LiquidatorFacet.sol";
import {PerpFuturesFacet} from "../facets/PerpFuturesFacet.sol";
import {PerpOptionsFacet} from "../facets/PerpOptionsFacet.sol";
import {PoolControllerFacet} from "../facets/PoolControllerFacet.sol";
import {TWAPFacet} from "../facets/TWAPFacet.sol";
import {XinfinityLPManagerFacet} from "../facets/XinfinityLPManagerFacet.sol";
import {ViewFacet} from "../facets/ViewFacet.sol";
import {console} from "../lib/forge-std/src/console.sol";
contract DeployXinfinity is Test {
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
    address public xinfinityLPManagerFacet;
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
    bytes4[] internal xinfinityLPManagerSelectors;
    bytes4[] internal viewSelectors;

    function getSelector(string memory _func) internal pure returns (bytes4) {
        return bytes4(keccak256(bytes(_func)));
    }

    function run() external {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        address owner = vm.addr(privateKey);

        console.log("Deploying contracts, with address: ", owner);

        vm.startBroadcast(privateKey); // pass the input key

        address xinfinityFactory = 0xB4a85Aa632777692CA0D12b842e7109121bF6bA6;
        address NFTDescriptor = 0x9AD6e4C397Aff843f38AC3982283a60fF53a0D1D;
        address xinfinityManager = 0x27f1B6A8b7347567b6e657ebD3E38d814F46c657;

        // Selectors per contract
        loupeSelectors = [
            IDiamond.facets.selector,
            IDiamond.facetFunctionSelectors.selector,
            IDiamond.facetAddresses.selector,
            IDiamond.facetAddress.selector
        ];

        leverageSelectors = [
            IDiamond.decreaseCollateralFutures.selector,
            IDiamond.decreaseCollateralOptions.selector,
            IDiamond.increaseCollateralFutures.selector,
            IDiamond.increaseCollateralOptions.selector
        ];

        liquidatorSelectors = [
            IDiamond.liquidateFuture.selector
        ];

        perpFuturesSelectors = [
            IDiamond.buyFutureContract.selector,
            IDiamond.sellFutureContract.selector,
            IDiamond.settleFutureContract.selector
        ];

        perpOptionsSelectors = [
            IDiamond.buyOptionContract.selector,
            IDiamond.exerciseOptionContract.selector,
            IDiamond.sellOptionContract.selector
        ];

        poolControllerSelectors = [
            IDiamond.collectAllFeesXinfin.selector,
            IDiamond.decreaseAllLiquidity.selector,
            IDiamond.increaseLiquidityCurrentRangeXinfin.selector,
            IDiamond.retrieveNFTXinfin.selector
        ];

        twapSelectors = [
            IDiamond.estimatePriceSupportedPools.selector,
            IDiamond.estimateWXDConXUSDT.selector
        ];

        xinfinityLPManagerSelectors = [
            IDiamond.collectAllFees.selector,
            IDiamond.decreaseLiquidityInHalf.selector,
            IDiamond.decreaseNecessaryLiquidity.selector,
            IDiamond.increaseLiquidityCurrentRange.selector,
            IDiamond.mintNewPosXinfin.selector,
            IDiamond.onERC721Received.selector,
            IDiamond.retrieveNFT.selector
        ];

        viewSelectors = [
            IDiamond.positionHealthFactorFutures.selector
        ];

        _diamondCut = address(new DiamondCutFacet());
        _diamond = address(new Diamond(owner, _diamondCut, xinfinityFactory, NFTDescriptor, xinfinityManager)); // precalculated address added
        _diamondLoupe = address(new DiamondLoupeFacet());
        leverageFacet = address(new LeverageFacet());
        liquidatorFacet = address(new LiquidatorFacet());
        perpFuturesFacet = address(new PerpFuturesFacet());
        perpOptionsFacet = address(new PerpOptionsFacet());
        poolControllerFacet = address(new PoolControllerFacet());
        twapFacet = address(new TWAPFacet());
        xinfinityLPManagerFacet = address(new XinfinityLPManagerFacet());
        viewFacet = address(new ViewFacet());

        IDiamond.FacetCut[] memory cut;

        cut = new IDiamond.FacetCut[](9);

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

        cut[2] = (
            IDiamond.FacetCut({
                facetAddress: leverageFacet,
                action: IDiamond.FacetCutAction.Add,
                functionSelectors: leverageSelectors
            })
        );

        cut[3] = (
            IDiamond.FacetCut({
                facetAddress: liquidatorFacet,
                action: IDiamond.FacetCutAction.Add,
                functionSelectors: liquidatorSelectors
            })
        );

        cut[4] = (
            IDiamond.FacetCut({
                facetAddress: perpFuturesFacet,
                action: IDiamond.FacetCutAction.Add,
                functionSelectors: perpFuturesSelectors
            })
        );

        cut[5] = (
            IDiamond.FacetCut({
                facetAddress: perpOptionsFacet,
                action: IDiamond.FacetCutAction.Add,
                functionSelectors: perpOptionsSelectors
            })
        );

        cut[6] = (
            IDiamond.FacetCut({
                facetAddress: poolControllerFacet,
                action: IDiamond.FacetCutAction.Add,
                functionSelectors: poolControllerSelectors
            })
        );

        cut[7] = (
            IDiamond.FacetCut({
                facetAddress: twapFacet,
                action: IDiamond.FacetCutAction.Add,
                functionSelectors: twapSelectors
            })
        );

        cut[8] = (
            IDiamond.FacetCut({
                facetAddress: xinfinityLPManagerFacet,
                action: IDiamond.FacetCutAction.Add,
                functionSelectors: xinfinityLPManagerSelectors
            })
        );

        assertNotEq(_diamond, address(0));
        assertNotEq(_diamondLoupe, address(0));
        assertNotEq(_diamondCut, address(0));
        assertNotEq(leverageFacet, address(0));
        assertNotEq(liquidatorFacet, address(0));
        assertNotEq(perpFuturesFacet, address(0));
        assertNotEq(perpOptionsFacet, address(0));
        assertNotEq(poolControllerFacet, address(0));
        assertNotEq(twapFacet, address(0));
        assertNotEq(xinfinityLPManagerFacet, address(0));
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
        console.log("LeverageFacet deployed with address: ", leverageFacet);
        console.log("LiquidatorFacet deployed with address: ", liquidatorFacet);
        console.log("PerpFuturesFacet deployed with address: ", perpFuturesFacet);
        console.log("PerpOptionsFacet deployed with address: ", perpOptionsFacet);
        console.log("PoolControllerFacet deployed with address: ", poolControllerFacet);
        console.log("TWAPFacet deployed with address: ", twapFacet);
        console.log("XinfinityLPManagerFacet deployed with address: ", xinfinityLPManagerFacet);
        console.log("ViewFacet deployed with address: ", viewFacet);
    }
}