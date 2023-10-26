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
  
  export const useExecuteFuture = (
    pool: `0x${string}`,
    owner: `0x${string}`,
    contractId: number
  ) => {
    const {
      config: createPerpFutureConfig,
      error: createPrepareFail,
      isError: hasCreatePrepareFailed,
      isFetching: isCreatePrepareFetching,
    } = usePrepareContractWrite({
      abi: PERP_FUTURES_ABI,
      address: Diamond,
      functionName:  "settleFutureContract",
      args: [pool, owner, contractId],
    });
  
    const { data: perpFutureData, write: executePerpFutureSettle } =
      useContractWrite(createPerpFutureConfig);
  
    const {
      isLoading: isPerpFutureSettleLoading,
      isSuccess: isPerpFutureSettleSuccessful,
      isError: isPerpFutureSettleFailed,
    } = useWaitForTransaction({
      hash: perpFutureData?.hash,
    });
  
    return {
      isPerpFutureSettleLoading,
      isPerpFutureSettleSuccessful,
      executePerpFutureSettle,
      createPrepareFail,
      hasCreatePrepareFailed,
      isCreatePrepareFetching,
      isPerpFutureSettleFailed,
    };
  };
  
  export const useExecuteOption = (
    pool: `0x${string}`,
    owner: `0x${string}`,
    contractId: number
  ) => {
    const {
      config: createPerpFutureExerciseConfig,
      error: createPrepareExerciseFail,
      isError: hasCreatePrepareExerciseFailed,
      isFetching: isCreatePrepareExerciseFetching,
    } = usePrepareContractWrite({
      abi: PERP_OPTIONS_ABI,
      address: Diamond,
      functionName: "exerciseOptionContract",
      args: [pool, owner, contractId],
    });
  
    const { data: perpOptionExerciseData, write: executePerpOptionExerciseFuture } =
      useContractWrite(createPerpFutureExerciseConfig);
  
    const {
      isLoading: isPerpOptionExerciseLoading,
      isSuccess: isPerpOptionExerciseSuccessful,
      isError: isPerpOptionExerciseFailed,
    } = useWaitForTransaction({
      hash: perpOptionExerciseData?.hash,
    });
  
    return {
      isPerpOptionExerciseLoading,
      isPerpOptionExerciseSuccessful,
      executePerpOptionExerciseFuture,
      createPrepareExerciseFail,
      hasCreatePrepareExerciseFailed,
      isCreatePrepareExerciseFetching,
      isPerpOptionExerciseFailed,
    };
  };
  