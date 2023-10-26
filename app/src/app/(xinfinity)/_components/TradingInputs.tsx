"use client";

import React, { useEffect, useState } from "react";
import { StrategyType } from "@/types/types";
import {useExecuteFuture, useExecuteOption} from "@/hooks/useExecutePosition";
import { useBuyFuture, useSellFuture } from "@/hooks/useTradeFuture";
import { useBuyOption, useSellOption } from "@/hooks/useTradeOptions";
import { poolData } from "@/lib/constants"

interface TradingInputsProps {
  currentStrategy: () => StrategyType;
  poolName: string;
}

interface FutureObject {
    direction: string;
    amount: number;
    leverage: number;
    token: string;
}

export const TradingInputs: React.FC<TradingInputsProps> = ({
  currentStrategy,
  poolName = "Loading...",
}) => {
  const [direction, setDirection] = useState<string | null>(null);
  const [token0, setToken0] = useState<string | null>(null);
  const [token1, setToken1] = useState<string | null>(null);
  const [futureObject, setFutureObject] = useState<FutureObject>({direction: currentStrategy() === StrategyType.FUTURES_LONG ? "Long" : "Short", amount: 0, leverage: 1, token: ""});
  // Mock user's positions and options data
  const userFuturesPositions: any[] = [];
  const userOptionsPositions: any[] = [];

  const tokens = poolName.split("-");
  const pool = poolData[0].address as `0x${string}`;
  const pool1 = poolData[1].address as `0x${string}`;

    const {
        executePerpBuyFuture,
    } = useBuyFuture(pool, pool1, 0);

  useEffect(() => {
    if (tokens.length === 2) {
      setToken0(tokens[0]);
      setToken1(tokens[1]);
    }

    switch (currentStrategy()) {
      case StrategyType.FUTURES_LONG:
        setDirection("Long");
        break;
      case StrategyType.FUTURES_SHORT:
        setDirection("Short");
        break;
      case StrategyType.OPTIONS_CALL:
        setDirection("Long");
        break;
      case StrategyType.OPTIONS_PUT:
        setDirection("Short");
        break;
      default:
        setDirection(null);
        break;
    }
  }, [currentStrategy, poolName]);

  return (
    <div className="mx-auto max-w-6xl rounded-lg bg-gray-800 p-4 pb-12 text-gray-200 shadow-md ">
      <div className="mb-2">
        <label className="mb-1 block text-xl font-bold text-gray-400">
          {currentStrategy() === StrategyType.CLOSE_FUTURE ||
          currentStrategy() === StrategyType.FUTURES_LONG || StrategyType.FUTURES_SHORT ? (
            <span>Futures</span>
          ) : (
            <span>Options</span>
          )}
        </label>
      </div>

      {(currentStrategy() === StrategyType.CLOSE_FUTURE ||
        currentStrategy() === StrategyType.CLOSE_OPTION) && (
        <div className="mb-4 grid grid-cols-2 gap-4">
          {currentStrategy() === StrategyType.CLOSE_FUTURE && !userFuturesPositions.length && (
              <div className="col-span-2 flex h-32 items-center justify-center">
                <span>No future positions available</span>
              </div>
            )}
          {currentStrategy() === StrategyType.CLOSE_OPTION && !userOptionsPositions.length && (
            <div className="col-span-2 flex h-32 items-center justify-center">
              <span>No option positions available</span>
            </div>
          )}
        </div>
      )}
      {currentStrategy() !== StrategyType.CLOSE_FUTURE &&
        currentStrategy() !== StrategyType.CLOSE_OPTION && (
          <>
            <div className="grid grid-cols-4 gap-4">
              <div>
                <label className="mb-1 block text-sm font-bold text-gray-400">
                  Direction:
                </label>
                <select
                        value={direction ?? ""}
                        className="block w-full rounded-md border bg-gray-700 py-1 text-gray-200"
                    >
                        <option value="Long">Long</option>
                        <option value="Short">Short</option>
                    </select>
                </div>
                <div>
                    <label className="mb-1 block text-sm font-bold text-gray-400">
                        Amount:
                    </label>
                    <input
                        type="number"
                        defaultValue={futureObject.amount}
                        onChange={(e) => setFutureObject((prevState) => ({...prevState, amount: Number(e.target.value)}))}
                        className="block w-full rounded-md border bg-gray-700 py-1 text-gray-200"
                />
              </div>
              {(currentStrategy() === StrategyType.OPTIONS_CALL ||
                currentStrategy() === StrategyType.OPTIONS_PUT) && (
                <>
                  <div>
                    <label className="mb-1 block text-sm font-bold text-gray-400">
                      Strike price:
                    </label>
                    <input
                      type="number"
                      defaultValue={0}
                      className="block w-full rounded-md border bg-gray-700 py-1 text-gray-200"
                    />
                  </div>
                  {currentStrategy() === StrategyType.OPTIONS_CALL && (
                  <div>
                    <label className="mb-1 block text-sm font-bold text-gray-400">
                      Premium:
                    </label>
                    <input
                      type="number"
                      className="block w-full rounded-md border bg-gray-700 py-1 text-gray-200"
                    />
                  </div>
                  )}
                </>
              )}
              <div>
                <label className="mb-1 block text-sm font-bold text-gray-400">
                  Borrow Amount:
                </label>
                <input
                  type="number"
                  value={futureObject.amount * futureObject.leverage}
                  className="block w-full rounded-md border bg-gray-700 py-1 text-gray-200"
                />
              </div>
              <div>
                <label className="mb-1 block text-sm font-bold text-gray-400">
                  Token:
                </label>
                <select className="block w-full rounded-md border bg-gray-700 py-1 text-gray-200">
                  <option value={token0 ?? ""}>{token0 ?? ""}</option>
                  <option value={token1 ?? ""}>{token1 ?? ""}</option>
                </select>
              </div>
            </div>

            <div className="mt-4 grid grid-cols-3 gap-4">
              <div>
                <label className="mb-1 block text-sm font-bold text-gray-400">
                  Leverage:
                </label>
                <input
                  type="number"
                    defaultValue={futureObject.leverage}
                  onChange={(e) => setFutureObject((prevState) => ({...prevState, leverage: Number(e.target.value)}))}
                  className="block w-full rounded-md border bg-gray-700 py-1 text-gray-200"
                />
              </div>
              {(currentStrategy() === StrategyType.FUTURES_LONG ||
                currentStrategy() === StrategyType.FUTURES_SHORT) && (
                <>
                <div>
                  <label className="mb-1 block text-sm font-bold text-gray-400">
                    Margin:
                  </label>
                  <input
                    type="text"
                    placeholder="%"
                    value={100 / futureObject.leverage}
                    className="block w-full rounded-md border bg-gray-700 py-1 text-gray-200"
                  />
                </div>
                <div>
                  <label className="mb-1 block text-sm font-bold text-gray-400">
                    Maintenance Margin:
                  </label>
                  <input
                    type="text"
                    placeholder="%"
                    value={(100 / futureObject.leverage) / 2}
                    className="block w-full rounded-md border bg-gray-700 py-1 text-gray-200"
                  />
                </div>
                </>
              )}
              <div className="col-span-2 flex flex-col items-end">
                <button onClick={executePerpBuyFuture} className="mt-4 rounded-lg bg-blue-500 px-4 py-2 font-bold text-white hover:bg-blue-600">
                  Execute Trade
                </button>
              </div>
            </div>
          </>
        )}
    </div>
  );
};
