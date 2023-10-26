# Xinfinity - First Futures and Options Perpetual DEX ever

![Xinfinity Protocol Schema](https://github.com/alex-alra-arteaga/Xinfinity/blob/main/app/public/baner.png?raw=true)
A decentralized perpetual exchange protocol built on XSwap v3. This document offers an insight into the protocol's mechanics, its design, and associated smart contracts.

# Website

[Link to Website](#) - Need to deploy in vercel



# Blockend

## Install

Everything is already installed!

```bash

## Build

$ forge build
```

I have commited the `out/` folder so you don't have to build it yourself.😁

## Overview

The protocol not only facilitates the trading of perpetual contracts but also ensures seamless liquidity provision atop the XSwap V3 pool. It encompasses the following functionalities:

- **Trading**: Involves perpetual contracts like futures and options.
- **Position Management**: Open or close short and long positions with an adaptable leverage mechanism.
- **Options Market**: Facilitates the buying and selling of options at diverse strike prices.
- **Liquidity Provision**: LPs (Liquidity Providers) are given the capacity to deposit, withdraw, and even collect fees.

### Protocol Design

![Xinfinity Protocol Schema](https://github.com/alex-alra-arteaga/Xinfinity/blob/main/app/public/protocolSchema.png?raw=true)

### Liquidity Provider Journey 

![Xinfinity Protocol Schema](https://github.com/alex-alra-arteaga/Xinfinity/blob/main/app/public/LiquidityProvider.png?raw=true)
1. **Deposit Liquidity**: LPs can deposit liquidity into the Xinfinity pool. This liquidity is then used to facilitate trades.
        https://github.com/alex-alra-arteaga/Xinfinity/blob/b5c335d211969592731dc5ca63cfe9336bf70839/blockend/facets/XinfinityLPManagerFacet.sol#L70

2. **Manager <==> pool**: The manager transfers the liquidity to the protocol pool, which is independent from the XSwap V3 pool.
        https://github.com/alex-alra-arteaga/Xinfinity/blob/b5c335d211969592731dc5ca63cfe9336bf70839/blockend/facets/XinfinityLPManagerFacet.sol#L96

3. **CollectFees**: LPs can collect fees from the protocol pool. This fees are generated by the premium options buyers and sellers pay and also by the traders that use leverage.
        https://github.com/alex-alra-arteaga/Xinfinity/blob/b5c335d211969592731dc5ca63cfe9336bf70839/blockend/facets/XinfinityLPManagerFacet.sol#L139


### Trader's Journey

![Xinfinity Protocol Schema](https://github.com/alex-alra-arteaga/Xinfinity/blob/main/app/public/traders.png?raw=true)

1. **Create Position**: Traders can create positions by depositing liquidity into the XSwap V3 pool. Take advatnage of the Xinity pool to trade with leverage.

https://github.com/alex-alra-arteaga/Xinfinity/blob/b5c335d211969592731dc5ca63cfe9336bf70839/blockend/facets/PoolControllerFacet.sol#L37

2. **Manage Position**: Traders can manage their positions by depositing or withdrawing liquidity from the XSwap V3 pool via the Manager, if they one they can hold the position for as long as they want.

    https://github.com/alex-alra-arteaga/Xinfinity/blob/b5c335d211969592731dc5ca63cfe9336bf70839/blockend/facets/PoolControllerFacet.sol#L96

    https://github.com/alex-alra-arteaga/Xinfinity/blob/b5c335d211969592731dc5ca63cfe9336bf70839/blockend/facets/PoolControllerFacet.sol#L62

  

3. **Close Position**: Traders can close their positions by withdrawing liquidity from the XSwap V3 pool. And have it returned back to their wallet with the profits or losses.

### Other important actors 🎭



- **Liquidators**: Entities ensuring market health.
  ![Xinfinity Liquidators](https://github.com/alex-alra-arteaga/Xinfinity/blob/main/app/public/Liquidator.png?raw=true)
  https://github.com/alex-alra-arteaga/Xinfinity/blob/b5c335d211969592731dc5ca63cfe9336bf70839/blockend/facets/LiquidatorFacet.sol#L15

  - <u>*Incentives*</u>: Liquidators are incentivized to maintain market health by receiving a portion of the liquidated trader's collateral. Additionally, we have implemented a *Funding Rate* mechanism to ensure that the price of the perpetual contract aligns closely with the price of the underlying asset. If the perpetual contract's price is higher than that of the underlying asset, long positions pay short positions, and vice versa. This mechanism is implemented in the *PerpFuturesFacet* contract.

## Features 🚀

### Current Features 
- **Pool Factory**: Streamlines the creation of pools atop the existing XSwap V3 pool.
- **"PROTOCOL" POOL**: Serves as centralized pools that champion the trading of pairs and foster seamless interaction with perpetuals while managing liquidity.
- **Liquidity Position Manager**: Overseeing the process of depositing and retracting liquidity at varied price levels (K) within XSwap.

### Coming Soon 
- **Liquidity Mining Hook**: Proposes incentives for the integration pool, granting projects the ability to bestow liquidity rewards upon their LPs.


## Contracts Addresses on XDC Mainnet ⛓

- **Diamond**: `0x2c678c775E706cA552016C9c447983167463124a`
  - *Called Contract via DelegateCall holds all the selectors to execute all functions form all facets + libraries*
- **DiamondLoupeFacet**: `0x5EE3eb77934A63Ad1CB781237D5c65f9841501ef`
  - *Basic functions to get information about the diamond*
- **DiamondCutFacet**: `0x75bAD9C79AfcbF16D6442AdA858AD6f9464aB0F8`
  - *Necessary contract to manage the Diamond Facets: Add / Remove / Remplace*
- **LeverageFacet**: `0x6b1e9FDa3240b1bc090b89bb7770c327f038F205`
  - *Facet to manage the leverage of the positions*
- **LiquidatorFacet**: `0x8dA38026f5bB57D20485299903858092AD9C9fBA`
  - *Facet to manage the liquidations of the positions*
- **PerpFuturesFacet**: `0x48fe128C8259A8D400c53464b1384bbd2eD38745`
  - *Facet to manage the Perpetuals FUTURES*
- **PerpOptionsFacet**: `0xdb3E5711B3A9EA56d6c0771610877e628548FbAd`
  - *Facet to manage the Perpetuals OPTIONS*
- **PoolControllerFacet**: `0x8A84c4d5834c9CB2F9D04A7e819B07c781E563a0`
  - *Facet to manage the interactions with XSwap*
- **TWAPFacet**: `0x800Ca19142b4d2d9eDf43d48785037B887b0B0CB`
  - *Oracle to get the price of the assets "From XSwap"*
- **XinfinityLPManagerFacet**: `0x75a1E631E5307062C0C7494F4E9e258dbbE4c659`
  - *Similar as PoolController but for the protocol own pools (Not XSwap) => (Yes Xinfinity)*
- **ViewFacet**: `0x67BF1837711370cB3E128f44BE21c08EbcE5CD1A`
  - *Facet to get information about the positions, pools, etc.*
- **XinfinityFactory**: `0xB4a85Aa632777692CA0D12b842e7109121bF6bA6`
  - *Route Factory to crate pools and other contracts*
- **NFTDescriptor**: `0x9AD6e4C397Aff843f38AC3982283a60fF53a0D1D`
  - *Necessary for hte Manager to get the information of the NFTs*
- **XinfinityManager**: `0x27f1B6A8b7347567b6e657ebD3E38d814F46c657`
  - *Acts as a midelware between the XinfinityLPManagerFacet and the Pool, is a helper that aids in the process*


## License

This project is licensed under the [MIT License](LICENSE.md) - see the file for details.
