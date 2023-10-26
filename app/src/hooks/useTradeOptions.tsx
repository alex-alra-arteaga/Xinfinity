import {
    useContractReads,
    useContractWrite,
    usePrepareContractWrite,
    useWaitForTransaction,
  } from "wagmi";
  import {
    Diamond,
    DIAMOND_ABI,
    LEVERAGE_ABI,
    LIQUIDATOR_ABI,
    PERP_FUTURES_ABI,
    PERP_OPTIONS_ABI,
    VIEW_ABI,
  } from "../../constants";

  enum TradingDirection {
    CALL = 0,
    PUT = 1,
  }
  
  export const useSellOption = (
    amount: bigint,
    strikePrice: bigint,
    tokenAddress: `0x${string}`,
    pool: `0x${string}`,
    poolFee: number,
    leverage: number,
  ) => {
    const optionParamsStruct = {
      amount,
      strike: strikePrice,
      token: tokenAddress,
      pool,
      poolFee,
      leverage,
      token0: `0x`.padEnd(40, `0`) as `0x${string}`,
      token1: `0x`.padEnd(40, `0`) as `0x${string}`,
      optionType: 1
    };
  
    const {
      config: createPerpOptionSellConfig,
      error: createPrepareOptionSellFail,
      isError: hasCreatePreparOptionSellFailed,
      isFetching: isCreateOptionSellFetching,
    } = usePrepareContractWrite({
      abi: PERP_OPTIONS_ABI,
      address: Diamond,
      functionName:  "sellOptionContract",
      args: [optionParamsStruct],
    });
  
    const { data: perpFutureData, write: executePerpFuture } =
      useContractWrite(createPerpOptionSellConfig);
  
    const {
      isLoading: isPerpOptionSellLoading,
      isSuccess: isPerpOptionSellSuccessful,
      isError: isPerpOptionSellFailed,
    } = useWaitForTransaction({
      hash: perpFutureData?.hash,
    });
  
    return {
        isPerpOptionSellLoading,
        isPerpOptionSellSuccessful,
      executePerpFuture,
      createPrepareOptionSellFail,
      hasCreatePreparOptionSellFailed,
      isCreateOptionSellFetching,
      isPerpOptionSellFailed,
    };
  };
  
  export const useBuyOption = (
    pool: `0x${string}`,
    owner: `0x${string}`,
    contractId: number
  ) => {
    const {
      config: createPerpOptionConfig,
      error: createPrepareFail,
      isError: hasCreatePrepareFailed,
      isFetching: isCreatePrepareFetching,
    } = usePrepareContractWrite({
      abi: PERP_FUTURES_ABI,
      address: Diamond,
      functionName: "buyFutureContract",
      args: [pool, owner, contractId, 0],
    });
  
    const { data: perpOptionBuyData, write: executePerpBuyOption } =
      useContractWrite(createPerpOptionConfig);
  
    const {
      isLoading: isPerpBuyOptionLoading,
      isSuccess: isPerpBuyOptionSuccessful,
      isError: isPerpBuyOptionFailed,
    } = useWaitForTransaction({
      hash: perpOptionBuyData?.hash,
    });
  
    return {
        isPerpBuyOptionLoading,
        isPerpBuyOptionSuccessful,
      executePerpBuyOption,
      createPrepareFail,
      hasCreatePrepareFailed,
      isCreatePrepareFetching,
      isPerpBuyOptionFailed,
    };
  };
  