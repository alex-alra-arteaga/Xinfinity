# Xinfinity - First Futures and Options Perpetual DEX ever

A decentralized perpetual exchange protocol built on XSwap v3. This document offers an insight into the protocol's mechanics, its design, and associated smart contracts.

# Website

[Link to Website](#) - Need to deploy in vercel


# Blockend

## Install

Everything is already installed!

```bash

## Build

```bash	
$ forge build
```



I have commited the `out/` folder so you don't have to build it yourself.


## Overview

The protocol not only facilitates the trading of perpetual contracts but also ensures seamless liquidity provision atop the XSwap V3 pool. It encompasses the following functionalities:

- **Trading**: Involves perpetual contracts like futures and options.
- **Position Management**: Open or close short and long positions with an adaptable leverage mechanism.
- **Options Market**: Facilitates the buying and selling of options at diverse strike prices.
- **Liquidity Provision**: LPs (Liquidity Providers) are given the capacity to deposit, withdraw, and even collect fees.

### Protocol Design

![Xinfinity Protocol Schema](https://github.com/alex-alra-arteaga/Xinfinity/blob/main/app/public/protocolSchema.png?raw=true)



### Key Actors:
- **LP Providers**: Those who provide liquidity.
  - <u>*Xinfinity LP Providers*</u>: Interact with the protocol pools that are independent form the XSwap V3 pool.
- **Option Traders**: Both buyers and sellers.
  - <u>*Traders*</u>: When a trader buys an option, they are given the right to purchase or sell an asset at a specific price. When a trader sells an option, they are obligated to purchase or sell an asset at a specific price. They need to pay a premium if option is choosed. They can acces the protocol liquidity to make possible the trade, even with leverage if they want.
  - <u>*Xswap usage*</u>: To create positions we add concentred liquidity to the XSwap V3 pool. Depending on the type of positions we will add to one segment or another to be complient with the business logic. 
- **Liquidators**: Entities ensuring market health.
  - <u>*Incentives*</u>: Liquidators are incentivized to maintain the market's health by receiving a portion of the liquidated trader's collateral. Also we have implemented a *Funding Rate* mechanims to ensure that the price of the perpetual contract is close to the price of the underlying asset. If the price of the perpetual contract is higher than the price of the underlying asset, long positions pay short positions. If the price of the perpetual contract is lower than the price of the underlying asset, short positions pay long positions. Is implemented in the *PerpFuturesFacet* contract.

## Features

### Current Features
- **Pool Factory**: Streamlines the creation of pools atop the existing XSwap V3 pool.
- **"PROTOCOL" POOL**: Serves as centralized pools that champion the trading of pairs and foster seamless interaction with perpetuals while managing liquidity.
- **Liquidity Position Manager**: Overseeing the process of depositing and retracting liquidity at varied price levels (K) within XSwap.

### Coming Soon
- **Liquidity Mining Hook**: Proposes incentives for the integration pool, granting projects the ability to bestow liquidity rewards upon their LPs.


## Contracts Addresses on XDC Mainnet

- **Diamond**: `0x2c678c775E706cA552016C9c447983167463124a`
- **DiamondLoupeFacet**: `0x5EE3eb77934A63Ad1CB781237D5c65f9841501ef`
- **DiamondCutFacet**: `0x75bAD9C79AfcbF16D6442AdA858AD6f9464aB0F8`
- **LeverageFacet**: `0x6b1e9FDa3240b1bc090b89bb7770c327f038F205`
- **LiquidatorFacet**: `0x8dA38026f5bB57D20485299903858092AD9C9fBA`
- **PerpFuturesFacet**: `0x48fe128C8259A8D400c53464b1384bbd2eD38745`
- **PerpOptionsFacet**: `0xdb3E5711B3A9EA56d6c0771610877e628548FbAd`
- **PoolControllerFacet**: `0x8A84c4d5834c9CB2F9D04A7e819B07c781E563a0`
- **TWAPFacet**: `0x800Ca19142b4d2d9eDf43d48785037B887b0B0CB`
- **XinfinityLPManagerFacet**: `0x75a1E631E5307062C0C7494F4E9e258dbbE4c659`
- **ViewFacet**: `0x67BF1837711370cB3E128f44BE21c08EbcE5CD1A`
- **XinfinityFactory**: `0xB4a85Aa632777692CA0D12b842e7109121bF6bA6`
- **NFTDescriptor**: `0x9AD6e4C397Aff843f38AC3982283a60fF53a0D1D`
- **XinfinityManager**: `0x27f1B6A8b7347567b6e657ebD3E38d814F46c657`
