"use client";
import React, { useEffect, useState } from "react";
import { Pool } from "../../_components/pools";
import { useRouter } from "next/navigation";
import {
  CategoryScale,
  Chart as ChartJS,
  LinearScale,
  LineElement,
  PointElement,
  Tooltip,
} from "chart.js";
import { Line } from "react-chartjs-2";
import StrategySidebar from "../../_components/sideBar";
import { StrategyType } from "../../../../types/types";
import { TradingInputs } from "../../_components/TradingInputs";

ChartJS.register(
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  Tooltip,
);

interface TemplateIdPageProps {
  params: {
    id: string;
  };
}

const TemplateIdPage: React.FC<TemplateIdPageProps> = ({ params }) => {
  const [currentChart, setCurrentChart] = useState<string>("FUTURES_SHORT");
  const [strategy, setStrategy] = useState<StrategyType>(
    StrategyType.FUTURES_SHORT,
  );

  const updateButton = (newState: StrategyType) => {
    setStrategy(newState);
  };

  const getState = () => strategy!;

  useEffect(() => {
    console.log(strategy);
    setCurrentChart(
      strategy === StrategyType.FUTURES_SHORT
        ? "FUTURES_SHORT"
        : strategy === StrategyType.FUTURES_LONG
        ? "FUTURES_LONG"
        : strategy === StrategyType.OPTIONS_PUT
        ? "OPTIONS_PUT"
        : strategy === StrategyType.OPTIONS_CALL
        ? "OPTIONS_CALL"
        : strategy === StrategyType.CLOSE_FUTURE
        ? "FUTURES_LONG"
        : strategy === StrategyType.CLOSE_OPTION
        ? "OPTIONS_CALL"
        : "FUTURES_SHORT",
    );
  }, [strategy]);

  const [legs, setLegs] = useState<Array<{ type: string; value: number }>>([
    {
      type: "Put",
      value: 1606.854,
    },
  ]);
  // Don't forget to define these functions somewhere in your component or its parent:

  const getChartData = () => {
    let chartColor;

    switch (currentChart) {
      case "FUTURES_SHORT":
        chartColor = "rgba(255, 0, 0, 0.9)"; // red
        break;
      case "FUTURES_LONG":
        chartColor = "rgba(0, 255, 0, 0.9)"; // green
        break;
      case "OPTIONS_PUT":
        chartColor = "rgba(255, 0, 0, 0.9)"; // red
        break;
      case "OPTIONS_CALL":
        chartColor = "rgba(0, 255, 0, 0.9)"; // green
        break;
      default:
        chartColor = "gray"; // default color if none matches
    }

    // y = mx + n
    const longPerp = (arr: number[]) => {
      if (arr.length === 0) {
        return [];
      }

      const max = Math.max(...arr);
      const m = max === 0 ? 0 : max / (arr.length - 1);

      const result = arr.map((_, index) => m * index);

      return result;
    };

    // Create a Long Call function
    const longCall = (arr: number[]) => {
      const min = Math.min(...arr);
      const out = arr.map((n, i) => i < (arr.length - 1) / 2 ? min - 10 : null);
      const full = longPerp(arr);
      const prep = full.slice((arr.length - 1) / 2);
      const comb = [...out.filter((n) => n !== null), ...prep];

      return comb;
    };

    // CHANGEME: replace with our data @Alex
    const origData = [100, 120, 115, 134, 168, 132, 200];

    // render depending on currentChart
    return {
      labels: [
        "2023-01",
        "2023-02",
        "2023-03",
        "2023-04",
        "2023-05",
        "2023-06",
        "2023-07",
      ],
      datasets: [
        {
          data: origData,
          backgroundColor: chartColor,
          borderColor: chartColor,
          fill: false,
          borderWidth: 2,
          pointBackgroundColor: chartColor,
        },
        /*
        {
          data: longPerp(origData),
          backgroundColor: "rgba(0, 255, 0, 0.9)",
          borderColor: "rgba(0, 255, 0, 0.9)",
          fill: false,
          borderWidth: 2,
          pointBackgroundColor: "rgba(0, 255, 0, 0.9)",
        },
        {
          data: longPerp(origData).reverse(), // aka shortPerp
          backgroundColor: "rgba(255, 0, 0, 0.9)",
          borderColor: "rgba(255, 0, 0, 0.9)",
          fill: false,
          borderWidth: 2,
          pointBackgroundColor: "rgba(255, 0, 0, 0.9)",
        },
        */
        {
          data: longCall(origData),
          backgroundColor: "rgba(0, 255, 0, 0.9)",
          borderColor: "rgba(0, 255, 0, 0.9)",
          fill: false,
          borderWidth: 2,
          pointBackgroundColor: "rgba(0, 255, 0, 0.9)",
        },
      ],
    };
  };

  /*
  |
  |
  |
  |
  |
  |
    ^ ^ ^ ^ ^ ^ ^
  */

  return (
    // from-black via-indigo-900 to-black p-4 text-white
    <div className="bg-gradient-to-b from-black via-indigo-900 to-black p-4text-white">
      <div className="flex h-screen items-center justify-center ">
        {/* <div className="h-3/4 w-full max-w-6xl overflow-auto rounded border border-gray-300 p-10 shadow"> */}
        <StrategySidebar
          id={params.id}
          strategyFn={updateButton}
          currentStrategy={getState}
        />
        <div className="mt-20 relative max-h-[80vh] w-3/4 max-w-6xl rounded border border-gray-300 p-10 shadow">
          <div className="mb-2">
            <button
              onClick={() => setCurrentChart("FUTURES_SHORT")}
              className={`mr-2 rounded border px-4 py-2 ${
                currentChart === "FUTURES_SHORT"
                  ? "bg-gray-300 text-black"
                  : "text-white"
              }`}
            >
              Futures - Short
            </button>
            <button
              onClick={() => setCurrentChart("FUTURES_LONG")}
              className={`mr-2 rounded border px-4 py-2 ${
                currentChart === "FUTURES_LONG"
                  ? "bg-gray-300 text-black"
                  : "text-white"
              }`}
            >
              Futures - Long
            </button>
            <button
              onClick={() => setCurrentChart("OPTIONS_PUT")}
              className={`mr-2 rounded border px-4 py-2 ${
                currentChart === "OPTIONS_PUT"
                  ? "bg-gray-300 text-black"
                  : "text-white"
              }`}
            >
              Options - Put
            </button>
            <button
              onClick={() => setCurrentChart("OPTIONS_CALL")}
              className={`mr-2 rounded border px-4 py-2 ${
                currentChart === "OPTIONS_CALL"
                  ? "bg-gray-300 text-black"
                  : "text-white"
              }`}
            >
              Options - Call
            </button>
            <div className="absolute top-2 right-4 text-white font-bold text-3xl">
              {params.id}
            </div>
          </div>

          {currentChart === "FUTURES_SHORT" && (
            <Line
              data={getChartData()}
              options={{
                scales: {
                  x: {
                    grid: {
                      color: "rgba(255, 255, 255, 0.1)", // Light grid lines
                    },
                  },
                  y: {
                    grid: {
                      color: "rgba(255, 255, 255, 0.1)", // Light grid lines
                    },
                  },
                },
              }}
            />
          )}
          {currentChart === "FUTURES_LONG" && (
            <Line
              data={getChartData()}
              options={{
                scales: {
                  x: {
                    grid: {
                      color: "rgba(255, 255, 255, 0.1)", // Light grid lines
                    },
                  },
                  y: {
                    grid: {
                      color: "rgba(255, 255, 255, 0.1)", // Light grid lines
                    },
                  },
                },
              }}
            />
          )}
          {currentChart === "OPTIONS_PUT" && (
            <Line
              data={getChartData()}
              options={{
                scales: {
                  x: {
                    grid: {
                      color: "rgba(255, 255, 255, 0.1)", // Light grid lines
                    },
                  },
                  y: {
                    grid: {
                      color: "rgba(255, 255, 255, 0.1)", // Light grid lines
                    },
                  },
                },
              }}
            />
          )}
          {currentChart === "OPTIONS_CALL" && (
            <Line
              data={getChartData()}
              options={{
                scales: {
                  x: {
                    grid: {
                      color: "rgba(255, 255, 255, 0.1)", // Light grid lines
                    },
                  },
                  y: {
                    grid: {
                      color: "rgba(255, 255, 255, 0.1)", // Light grid lines
                    },
                  },
                },
              }}
            />
          )}
          {
            /* <div className="mb-10 mt-4 flex justify-center space-x-4 mb-10">
          <button
            onClick={() => handleBuyAction()}
            className="transform rounded border bg-green-500 px-4 py-2 shadow-md transition-transform hover:scale-105 hover:bg-green-600"
          >
            Buy
          </button>
          <button
            onClick={() => handleSellAction()}
            className="transform rounded border bg-red-500 px-4 py-2 shadow-md transition-transform hover:scale-105 hover:bg-red-600"
          >
            Sell
          </button>
        </div> */
          }
        </div>
      </div>
      <div className="pl-[350px]">
        <TradingInputs
          currentStrategy={getState}
          poolName={params.id as string}
        />
      </div>
    </div>
  );
};

export default TemplateIdPage;
