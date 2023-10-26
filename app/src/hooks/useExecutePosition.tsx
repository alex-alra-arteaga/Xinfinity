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
    address: string,
    pool: string,
    poolFee: number,
    leverage: number,
    tradeDirection: TradingDirection,
  ) => {
    const futureParamsStruct = {
      deadline: deadline,
      maxSupply: numOfParticpants,
      pricePerToken: pricePerEntry,
      numOfWinners: numOfWinners,
    };
  
    const {
      config: createRaffleConfig,
      error: createPrepareFail,
      isError: hasCreatePrepareFailed,
      isFetching: isCreatePrepareFetching,
    } = usePrepareContractWrite({
      abi: CORE_RAFFLE_ADDRESS_ABI,
      address: TESTNET_CORE_RAFFLE_ADDRESS,
      functionName: "raffleFactory",
      args: [name, symbol, baseUri, createRaffleConfigStruct],
    });
  
    const { data: creatingData, write: executeRaffleDeploy } =
      useContractWrite(createRaffleConfig);
  
    const {
      isLoading: isDeploymentLoading,
      isSuccess: isDeploymentSuccessful,
      isError: isDeploymentFailed,
    } = useWaitForTransaction({
      hash: creatingData?.hash,
    });
  
    return {
      isDeploymentLoading,
      isDeploymentSuccessful,
      executeRaffleDeploy,
      createPrepareFail,
      hasCreatePrepareFailed,
      isCreatePrepareFetching,
      isDeploymentFailed,
    };
  };
  