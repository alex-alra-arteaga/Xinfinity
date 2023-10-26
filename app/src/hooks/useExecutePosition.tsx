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
  
  export const useSellFuture = (
    amount: bigint,
    tokenAddress: `0x${string}`,
    pool: `0x${string}`,
    ownerPosition: `0x${string}`,
    poolFee: number,
    leverage: number,
  ) => {
    const futureParamsStruct = {
      amount,
      token: tokenAddress,
      pool,
      poolFee,
      leverage,
      futureType: Number(futureType)
    };
  
    const {
      config: createPerpFutureConfig,
      error: createPrepareFail,
      isError: hasCreatePrepareFailed,
      isFetching: isCreatePrepareFetching,
    } = usePrepareContractWrite({
      abi: PERP_FUTURES_ABI,
      address: Diamond,
      functionName:  "sellFutureContract",
      args: [futureParamsStruct],
    });
  
    const { data: perpFutureData, write: executePerpFuture } =
      useContractWrite(createPerpFutureConfig);
  
    const {
      isLoading: isPerpFutureLoading,
      isSuccess: isPerpFutureSuccessful,
      isError: isPerpFutureFailed,
    } = useWaitForTransaction({
      hash: perpFutureData?.hash,
    });
  
    return {
      isPerpFutureLoading,
      isPerpFutureSuccessful,
      executePerpFuture,
      createPrepareFail,
      hasCreatePrepareFailed,
      isCreatePrepareFetching,
      isPerpFutureFailed,
    };
  };
  
  export const useTradeOption = (
    amount: bigint,
    strike: bigint,
    tokenAddress: `0x${string}`,
    pool: `0x${string}`,
    poolFee: number,
    leverage: number,
    optionType: TradingDirection,
  ) => {
    const optionParamsStruct = {
      amount,
      strike,
      token: tokenAddress,
      pool,
      poolFee,
      leverage,
      token0: `0x`.padEnd(40, "0"),
      token1: `0x`.padEnd(40, "0"),
      optionType: Number(optionType)
    };
  
    const {
      config: createPerpFutureConfig,
      error: createPrepareFail,
      isError: hasCreatePrepareFailed,
      isFetching: isCreatePrepareFetching,
    } = usePrepareContractWrite({
      abi: PERP_FUTURES_ABI,
      address: Diamond,
      functionName: futureType ? "buyFutureContract" : "sellFutureContract",
      args: [optionParamsStruct],
    });
  
    const { data: perpFutureData, write: executePerpFuture } =
      useContractWrite(createPerpFutureConfig);
  
    const {
      isLoading: isPerpFutureLoading,
      isSuccess: isPerpFutureSuccessful,
      isError: isPerpFutureFailed,
    } = useWaitForTransaction({
      hash: perpFutureData?.hash,
    });
  
    return {
      isPerpFutureLoading,
      isPerpFutureSuccessful,
      executePerpFuture,
      createPrepareFail,
      hasCreatePrepareFailed,
      isCreatePrepareFetching,
      isPerpFutureFailed,
    };
  };
  