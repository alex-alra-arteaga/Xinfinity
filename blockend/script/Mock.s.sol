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

contract Mock {
        enum FutureType {
        CALL,
        PUT
    }

    enum PerpType {
        FUTURE,
        OPTION
    }

    enum OrderStatus {
        UNINITIALIZED,
        MINTED,
        BOUGHT,
        EXERCISED,
        CANCELLED
    }
    struct PerpFuture {
        FutureType futureType; // call or put
        address xinfinityPool;
        uint256 initialPrice; // of the pool
        uint256 leverage; // equals margin in finance terms, in basis points
        uint256 collateralAmount; // amount set in collateral
        int256 fundingRatePayment; // extra tokens to pay to seller/buyer depending on funding rate
        address collateralToken; // token used as collateral
        uint256 borrowAmount; // amount borrowed from the pool
        uint256 maintenanceMargin; // % of collateral that must be maintained over borrowAmount, in basis points
        OrderStatus status;
    }

    struct PerpOption {
        OptionType optionType; // call or put
        address xinfinityPool; // pool address of the protocol, on top of xSwap pool
        uint256 initialPrice; // of the pool
        uint256 leverage; // borrowAmount / collateralAmount, in basis points
        uint256 strike; // strike price of the option
        uint256 collateralAmount; // amount set in collateral
        int256 fundingRatePayment; // extra tokens to pay to seller/buyer depending on funding rate
        address collateralToken; // token used as collateral
        uint256 borrowAmount; // amount borrowed from the pool
        uint256 premium; // amount of premium paid to the pool to cover LP risk
        OrderStatus status;
    }
        enum OptionType {
        CALL,
        PUT
    }

    struct OptionParams { 
        uint256 amount;
        uint256 strike;
        address token;
        address pool;
        uint24 poolFee;
        uint24 leverage;
        address token0;
        address token1;
        OptionType optionType;
    }

    struct FutureParams {
        uint256 amount;
        address token;
        address pool;
        uint24 poolFee;
        uint24 leverage;
        FutureType futureType;
    }

    mapping(address pool => mapping(address user => mapping(uint24 recordId => PerpOption))) optionRecord;
    mapping(address pool => mapping(address user => mapping(uint24 recordId => PerpFuture))) futureRecord;
    mapping(address pool => mapping(address user => uint24 numOfRecords)) numOfRecordFutures;
    mapping(address pool => mapping(address user => uint24 numOfRecords)) numOfRecordOptions;
    function buyOptionContract(
        address pool,
        address owner,
        uint24 contractId
    ) external {}

    function sellOptionContract(
        OptionParams memory param
    ) external returns (uint24 recordId) {
        recordId = numOfRecordOptions[param.pool][msg.sender]++;
        optionRecord[param.pool][msg.sender][recordId] = PerpOption({
            optionType: param.optionType,
            xinfinityPool: param.pool,
            initialPrice: 0,
            leverage: param.leverage,
            strike: param.strike,
            collateralAmount: param.amount,
            fundingRatePayment: 0,
            collateralToken: param.token,
            borrowAmount: 0,
            premium: 0,
            status: OrderStatus.MINTED
        });
    }

    function settleFutureContract(
        address pool,
        address owner,
        uint24 contractId
    ) external {}

     function buyFutureContract(
        address pool,
        address owner,
        uint24 contractId,
        FutureType futureType
    ) external {}

    function exerciseOptionContract(
        address pool,
        address owner,
        uint24 contractId
    ) external {}

    function sellFutureContract(FutureParams memory param) external returns (uint24 recordId) {
        recordId = numOfRecordFutures[param.pool][msg.sender]++;
        futureRecord[param.pool][msg.sender][recordId] = PerpFuture({
            futureType: param.futureType,
            xinfinityPool: param.pool,
            initialPrice: 0,
            leverage: param.leverage,
            collateralAmount: param.amount,
            fundingRatePayment: 0,
            collateralToken: param.token,
            borrowAmount: 0,
            maintenanceMargin: 0,
            status: OrderStatus.MINTED
        });
    }
}

contract DeployDependenciesCopy is Script {
    function setUp() public {}

    function run() public {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        address owner = vm.addr(privateKey);

        console.log("Deploying contracts, with address: ", owner);

        vm.startBroadcast(privateKey); // pass the input key

        Mock mock = new Mock();
        console.log("XinfinityFactory deployed, with address: ", address(mock));

        vm.stopBroadcast();
    }
}