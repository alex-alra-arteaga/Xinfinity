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
![Protocol Schema](../app/../Xinfinity/app/public/protocolSchema.png)



### Key Stakeholders:
- **LP Providers**: Those who provide liquidity.
- **Option Traders**: Both buyers and sellers.
- **Liquidators**: Entities ensuring market health.

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
