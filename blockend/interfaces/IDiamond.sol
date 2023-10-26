// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

interface IDiamond {
    struct Facet {
        address facetAddress;
        bytes4[] functionSelectors;
    }
    enum FacetCutAction {
        Add,
        Replace,
        Remove
    }
    struct FacetCut {
        address facetAddress;
        FacetCutAction action;
        bytes4[] functionSelectors;
    }
    function facets() external view returns (Facet[] memory facets_);

    function facetFunctionSelectors(
        address _facet
    ) external view returns (bytes4[] memory _facetFunctionSelectors);

    function facetAddresses()
        external
        view
        returns (address[] memory facetAddresses_);

    function facetAddress(
        bytes4 _functionSelector
    ) external view returns (address facetAddress_);

    function diamondCut(
        FacetCut[] calldata _diamondCut,
        address _init,
        bytes calldata _calldata
    ) external;
    // From ILeverageFacet
    function decreaseCollateralFutures(address pool, uint24 contractId, uint256 amount) external;
    function decreaseCollateralOptions(address pool, uint24 contractId, uint256 amount) external;
    function increaseCollateralFutures(address pool, uint24 contractId, uint256 amount) external;
    function increaseCollateralOptions(address pool, uint24 contractId, uint256 amount) external;

    // From ILiquidatorFacet
    function liquidateFuture(address pool, address owner, uint24 contractId) external;

    // From IPerpFuturesFacet
    struct FutureParams {
        uint256 amount;
        address token;
        address pool;
        uint24 poolFee;
        uint24 leverage;
        uint8 futureType;
    }
    function buyFutureContract(address pool, address owner, uint24 contractId, uint8 futureType) external;
    function sellFutureContract(FutureParams memory param) external returns (uint24 recordId);
    function settleFutureContract(address pool, address owner, uint24 contractId) external;

    // From IPerpOptionsFacet
    struct OptionParams {
        uint256 amount;
        uint256 strike;
        address token;
        address pool;
        uint24 poolFee;
        uint24 leverage;
        address token0;
        address token1;
        uint8 optionType;
    }
    function buyOptionContract(address pool, address owner, uint24 contractId) external;
    function exerciseOptionContract(address pool, address owner, uint24 contractId) external;
    function sellOptionContract(OptionParams memory param) external returns (uint24 recordId);

    // From IPoolControllerFacet
    function collectAllFeesXinfin(uint256 tokenId) external returns (uint256 amount0, uint256 amount1);
    function decreaseAllLiquidity(uint256 tokenId) external returns (uint256 amount0, uint256 amount1);
    function increaseLiquidityCurrentRangeXinfin(uint256 tokenId, uint256 amountAdd0, uint256 amountAdd1)
        external
        returns (uint128 liquidity, uint256 amount0, uint256 amount1);
    function retrieveNFTXinfin(uint256 tokenId) external;

    // From ITWAPFacet
    function estimatePriceSupportedPools(
        address tokenA,
        address tokenB,
        uint24 poolFee,
        uint128 amountIn,
        uint32 secondsAgo,
        bool isXSwapPool
    ) external view returns (uint256 amountOut);
    function estimateWXDConXUSDT(uint128 amountIn, uint32 secondsAgo) external view returns (uint256 amountOut);

    // From IXinfinityLPManagerFacet
    function collectAllFees(uint256 tokenId) external returns (uint256 amount0, uint256 amount1);
    function decreaseLiquidityInHalf(uint256[] memory tokenIds) external returns (uint256 amount0, uint256 amount1);
    function decreaseNecessaryLiquidity(uint256[] memory tokenIds, uint256 amount, bool isZeroToken)
        external
        returns (uint256 totalAmount0, uint256 totalAmount1);
    function increaseLiquidityCurrentRange(uint256 tokenId, uint256 amountAdd0, uint256 amountAdd1)
        external
        returns (uint128 liquidity, uint256 amount0, uint256 amount1);
    function mintNewPosXinfin(
        uint256 amount0ToMint,
        uint256 amount1ToMint,
        int24 tickDesired,
        uint24 poolFee,
        address token0,
        address token1
    ) external returns (uint256 tokenId, uint128 liquidity, uint256 amount0, uint256 amount1);
    function onERC721Received(address operator, address, uint256 tokenId, bytes memory) external returns (bytes4);
    function retrieveNFT(uint256 tokenId) external;

    // From IViewFacet
    function positionHealthFactorFutures(address pool, address owner, uint24 contractId)
        external
        view
        returns (bool isLiquidable, int256 actualMarginPercentage, int256 actualMarginAmount);
}


