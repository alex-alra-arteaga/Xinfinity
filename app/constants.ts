export const Diamond = "0x2c678c775E706cA552016C9c447983167463124a"
export const DiamondLoupeFacet = "0x5EE3eb77934A63Ad1CB781237D5c65f9841501ef"
export const DiamondCutFacet = "0x75bAD9C79AfcbF16D6442AdA858AD6f9464aB0F8"
export const LeverageFacet = "0x6b1e9FDa3240b1bc090b89bb7770c327f038F205"
export const LiquidatorFacet = "0x8dA38026f5bB57D20485299903858092AD9C9fBA"
export const PerpFuturesFacet = "0x48fe128C8259A8D400c53464b1384bbd2eD38745"
export const PerpOptionsFacet = "0xdb3E5711B3A9EA56d6c0771610877e628548FbAd"
export const PoolControllerFacet = "0x8A84c4d5834c9CB2F9D04A7e819B07c781E563a0"
export const TWAPFacet = "0x800Ca19142b4d2d9eDf43d48785037B887b0B0CB"
export const XinfinityLPManagerFacet = "0x75a1E631E5307062C0C7494F4E9e258dbbE4c659"
export const ViewFacet = "0x67BF1837711370cB3E128f44BE21c08EbcE5CD1A"
export const XinfinityFactory = "0xB4a85Aa632777692CA0D12b842e7109121bF6bA6"
export const NFTDescriptor = "0x9AD6e4C397Aff843f38AC3982283a60fF53a0D1D"
export const XinfinityManager = "0x27f1B6A8b7347567b6e657ebD3E38d814F46c657"
export const XDC = "0x6ecdf74085a20164d6ece95d6d27692763948149";
export const DIAMOND_ABI = [
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "_protocolOwner",
          "type": "address"
        },
        {
          "internalType": "address",
          "name": "_diamondCutFacet",
          "type": "address"
        },
        {
          "internalType": "address",
          "name": "_xinfinityFactory",
          "type": "address"
        },
        {
          "internalType": "address",
          "name": "_xinfinityNFTDescriptor",
          "type": "address"
        },
        {
          "internalType": "address",
          "name": "_xinfinityManager",
          "type": "address"
        }
      ],
      "stateMutability": "nonpayable",
      "type": "constructor"
    },
    {
      "inputs": [
        {
          "internalType": "bytes4",
          "name": "selector",
          "type": "bytes4"
        }
      ],
      "name": "FunctionNotFound",
      "type": "error"
    },
    {
      "stateMutability": "payable",
      "type": "fallback"
    }
  ] as const;
export const LEVERAGE_ABI = [
    {
      "inputs": [],
      "name": "IncorrectLeverage",
      "type": "error"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "pool",
          "type": "address"
        },
        {
          "internalType": "address",
          "name": "owner",
          "type": "address"
        },
        {
          "internalType": "uint256",
          "name": "contractId",
          "type": "uint256"
        }
      ],
      "name": "NotAvaibleFuture",
      "type": "error"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "pool",
          "type": "address"
        },
        {
          "internalType": "address",
          "name": "owner",
          "type": "address"
        },
        {
          "internalType": "uint256",
          "name": "contractId",
          "type": "uint256"
        }
      ],
      "name": "NotAvailableOption",
      "type": "error"
    },
    {
      "inputs": [],
      "name": "PositionsIsLiquidable",
      "type": "error"
    },
    {
      "inputs": [],
      "name": "TransferFailed",
      "type": "error"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "pool",
          "type": "address"
        },
        {
          "internalType": "uint24",
          "name": "contractId",
          "type": "uint24"
        },
        {
          "internalType": "uint256",
          "name": "amount",
          "type": "uint256"
        }
      ],
      "name": "decreaseCollateralFutures",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "pool",
          "type": "address"
        },
        {
          "internalType": "uint24",
          "name": "contractId",
          "type": "uint24"
        },
        {
          "internalType": "uint256",
          "name": "amount",
          "type": "uint256"
        }
      ],
      "name": "decreaseCollateralOptions",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "pool",
          "type": "address"
        },
        {
          "internalType": "uint24",
          "name": "contractId",
          "type": "uint24"
        },
        {
          "internalType": "uint256",
          "name": "amount",
          "type": "uint256"
        }
      ],
      "name": "increaseCollateralFutures",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "pool",
          "type": "address"
        },
        {
          "internalType": "uint24",
          "name": "contractId",
          "type": "uint24"
        },
        {
          "internalType": "uint256",
          "name": "amount",
          "type": "uint256"
        }
      ],
      "name": "increaseCollateralOptions",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    }
  ] as const;

export const LIQUIDATOR_ABI = [
    {
      "inputs": [],
      "name": "NotLiquidable",
      "type": "error"
    },
    {
      "inputs": [
        {
          "internalType": "contract IUniswapV3Pool",
          "name": "pool",
          "type": "address"
        },
        {
          "internalType": "address",
          "name": "owner",
          "type": "address"
        },
        {
          "internalType": "uint24",
          "name": "contractId",
          "type": "uint24"
        }
      ],
      "name": "liquidateFuture",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    }
  ] as const;

export const PERP_FUTURES_ABI = [
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "caller",
          "type": "address"
        },
        {
          "internalType": "address",
          "name": "diamond",
          "type": "address"
        }
      ],
      "name": "CallerCanOnlyBeDiamond",
      "type": "error"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "owner",
          "type": "address"
        }
      ],
      "name": "CannotBuyFromYourself",
      "type": "error"
    },
    {
      "inputs": [
        {
          "internalType": "uint256",
          "name": "collateral",
          "type": "uint256"
        },
        {
          "internalType": "uint256",
          "name": "maintenanceMargin",
          "type": "uint256"
        }
      ],
      "name": "CollateralBelowMaintenanceMargin",
      "type": "error"
    },
    {
      "inputs": [],
      "name": "IncorrectLeverage",
      "type": "error"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "pool",
          "type": "address"
        },
        {
          "internalType": "address",
          "name": "owner",
          "type": "address"
        },
        {
          "internalType": "uint256",
          "name": "contractId",
          "type": "uint256"
        }
      ],
      "name": "NotAvaibleFuture",
      "type": "error"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "pool",
          "type": "address"
        },
        {
          "internalType": "address",
          "name": "owner",
          "type": "address"
        },
        {
          "internalType": "uint256",
          "name": "contractId",
          "type": "uint256"
        }
      ],
      "name": "NotAvailableOption",
      "type": "error"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "token",
          "type": "address"
        },
        {
          "internalType": "address",
          "name": "token0",
          "type": "address"
        },
        {
          "internalType": "address",
          "name": "token1",
          "type": "address"
        }
      ],
      "name": "NotIncludedInPool",
      "type": "error"
    },
    {
      "inputs": [],
      "name": "NotSupportedPool",
      "type": "error"
    },
    {
      "inputs": [],
      "name": "TransferFailed",
      "type": "error"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "pool",
          "type": "address"
        },
        {
          "internalType": "address",
          "name": "owner",
          "type": "address"
        },
        {
          "internalType": "uint24",
          "name": "contractId",
          "type": "uint24"
        },
        {
          "internalType": "enum Types.FutureType",
          "name": "futureType",
          "type": "uint8"
        }
      ],
      "name": "buyFutureContract",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "components": [
            {
              "internalType": "uint256",
              "name": "amount",
              "type": "uint256"
            },
            {
              "internalType": "address",
              "name": "token",
              "type": "address"
            },
            {
              "internalType": "address",
              "name": "pool",
              "type": "address"
            },
            {
              "internalType": "uint24",
              "name": "poolFee",
              "type": "uint24"
            },
            {
              "internalType": "uint24",
              "name": "leverage",
              "type": "uint24"
            },
            {
              "internalType": "enum Types.FutureType",
              "name": "futureType",
              "type": "uint8"
            }
          ],
          "internalType": "struct Types.FutureParams",
          "name": "param",
          "type": "tuple"
        }
      ],
      "name": "sellFutureContract",
      "outputs": [
        {
          "internalType": "uint24",
          "name": "recordId",
          "type": "uint24"
        }
      ],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "contract IUniswapV3Pool",
          "name": "pool",
          "type": "address"
        },
        {
          "internalType": "address",
          "name": "owner",
          "type": "address"
        },
        {
          "internalType": "uint24",
          "name": "contractId",
          "type": "uint24"
        }
      ],
      "name": "settleFutureContract",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    }
  ] as const;

  export const PERP_OPTIONS_ABI = [
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "caller",
          "type": "address"
        },
        {
          "internalType": "address",
          "name": "diamond",
          "type": "address"
        }
      ],
      "name": "CallerCanOnlyBeDiamond",
      "type": "error"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "owner",
          "type": "address"
        }
      ],
      "name": "CannotBuyFromYourself",
      "type": "error"
    },
    {
      "inputs": [],
      "name": "IncorrectLeverage",
      "type": "error"
    },
    {
      "inputs": [
        {
          "internalType": "uint256",
          "name": "spotPrice",
          "type": "uint256"
        },
        {
          "internalType": "uint256",
          "name": "strike",
          "type": "uint256"
        }
      ],
      "name": "IncorrectStrike",
      "type": "error"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "pool",
          "type": "address"
        },
        {
          "internalType": "address",
          "name": "owner",
          "type": "address"
        },
        {
          "internalType": "uint256",
          "name": "contractId",
          "type": "uint256"
        }
      ],
      "name": "NotAvailableOption",
      "type": "error"
    },
    {
      "inputs": [],
      "name": "NotSupportedPool",
      "type": "error"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "pool",
          "type": "address"
        },
        {
          "internalType": "address",
          "name": "owner",
          "type": "address"
        },
        {
          "internalType": "uint24",
          "name": "contractId",
          "type": "uint24"
        }
      ],
      "name": "buyOptionContract",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "contract IUniswapV3Pool",
          "name": "pool",
          "type": "address"
        },
        {
          "internalType": "address",
          "name": "owner",
          "type": "address"
        },
        {
          "internalType": "uint24",
          "name": "contractId",
          "type": "uint24"
        }
      ],
      "name": "exerciseOptionContract",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "components": [
            {
              "internalType": "uint256",
              "name": "amount",
              "type": "uint256"
            },
            {
              "internalType": "uint256",
              "name": "strike",
              "type": "uint256"
            },
            {
              "internalType": "address",
              "name": "token",
              "type": "address"
            },
            {
              "internalType": "address",
              "name": "pool",
              "type": "address"
            },
            {
              "internalType": "uint24",
              "name": "poolFee",
              "type": "uint24"
            },
            {
              "internalType": "uint24",
              "name": "leverage",
              "type": "uint24"
            },
            {
              "internalType": "address",
              "name": "token0",
              "type": "address"
            },
            {
              "internalType": "address",
              "name": "token1",
              "type": "address"
            },
            {
              "internalType": "enum Types.OptionType",
              "name": "optionType",
              "type": "uint8"
            }
          ],
          "internalType": "struct Types.OptionParams",
          "name": "param",
          "type": "tuple"
        }
      ],
      "name": "sellOptionContract",
      "outputs": [
        {
          "internalType": "uint24",
          "name": "recordId",
          "type": "uint24"
        }
      ],
      "stateMutability": "nonpayable",
      "type": "function"
    }
  ] as const;

  export const VIEW_ABI = [
    {
      "inputs": [],
      "name": "NotSupportedPool",
      "type": "error"
    },
    {
      "inputs": [
        {
          "internalType": "contract IUniswapV3Pool",
          "name": "pool",
          "type": "address"
        },
        {
          "internalType": "address",
          "name": "owner",
          "type": "address"
        },
        {
          "internalType": "uint24",
          "name": "contractId",
          "type": "uint24"
        }
      ],
      "name": "positionHealthFactorFutures",
      "outputs": [
        {
          "internalType": "bool",
          "name": "isLiquidable",
          "type": "bool"
        },
        {
          "internalType": "int256",
          "name": "actualMarginPercentage",
          "type": "int256"
        },
        {
          "internalType": "int256",
          "name": "actualMarginAmount",
          "type": "int256"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    }
  ] as const;