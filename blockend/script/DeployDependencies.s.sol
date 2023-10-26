// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {PoolFactory} from "../utils/PoolFactory.sol";
import {NonfungiblePositionManager} from "../lib/v3-periphery/NonfungiblePositionManager.sol";
import {NonfungibleTokenPositionDescriptor} from "../lib/v3-periphery/NonfungibleTokenPositionDescriptor.sol";
import {Constants} from "../libraries/Constants.sol";
/**
 * @dev need to run source env (to load the env variables)
 */
contract DeployDependencies is Script {
    function setUp() public {}

    function run() public {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        address owner = vm.addr(privateKey);

        console.log("Deploying contracts, with address: ", owner);

        vm.startBroadcast(privateKey); // pass the input key

        // Deploy XinfinityFactory, NFTDescriptor and XinfinityManager
        PoolFactory factory = new PoolFactory();
        NonfungibleTokenPositionDescriptor descriptor = new NonfungibleTokenPositionDescriptor(Constants.WXDC, "");
        NonfungiblePositionManager manager = new NonfungiblePositionManager(address(factory), Constants.WXDC, address(descriptor));
        console.log("XinfinityFactory deployed, with address: ", address(factory));
        console.log("NFTDescriptor deployed, with address: ", address(descriptor));
        console.log("XinfinityManager deployed, with address: ", address(manager));

        vm.stopBroadcast();
    }
}