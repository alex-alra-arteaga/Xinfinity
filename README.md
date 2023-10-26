# Xinfinity - First Futures and Options Perpetual DEX ever



## Install

```bash
$ forge install https://github.com/Uniswap/v3-core.git --no-git
```

## Build

Important, you need to build the contracts with the `--via-ir` flag, otherwise the build will fail due to stack too deep in `PerpFuturesFacet::sellFutureContract()`.
```bash	
$ forge build --via-ir
```

I have commited the `out/` folder so you don't have to build it yourself.