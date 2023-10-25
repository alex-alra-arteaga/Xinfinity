"use client";
import React, { useState } from "react";
import { Pool } from "../../_components/pools";
import {
  Chart as ChartJS,
  CategoryScale,
  LinearScale,
  Tooltip,
  PointElement,
  LineElement,
} from "chart.js";
import { Line } from "react-chartjs-2";
import StrategySidebar from "../../_components/sideBar";

ChartJS.register(
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  Tooltip
);

interface TemplateIdPageProps {
  params: {
    id: string;
  };
}

const TemplateIdPage: React.FC<TemplateIdPageProps> = ({ params }) => {
  const [currentChart, setCurrentChart] = useState<string>("FUTURES_SHORT"); // default char
  const [strategy, setStrategy] = useState<string>('Short Put');
  const [legs, setLegs] = useState<Array<{ type: string, value: number }>>([{
      type: 'Put',
      value: 1606.854
  }]);
  // Don't forget to define these functions somewhere in your component or its parent:
  function handleBuyAction() {
    // Your logic for handling the buy action
  }

  function handleSellAction() {
    // Your logic for handling the sell action
  }

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
          data: [100, 120, 115, 134, 168, 132, 200],
          backgroundColor: chartColor,
          borderColor: chartColor,
          fill: false,
          borderWidth: 2,
          pointBackgroundColor: chartColor,
        },
      ],
    };
  };

  return (
    // from-black via-indigo-900 to-black p-4 text-white
    <div className="flex h-screen items-center justify-center bg-gradient-to-b from-black via-indigo-900 to-black p-4  text-white ">
      {/* <div className="h-3/4 w-full max-w-6xl overflow-auto rounded border border-gray-300 p-10 shadow"> */}
      <StrategySidebar />
      <div className="mt-20 max-h-[80vh] w-3/4 max-w-6xl rounded border border-gray-300  p-10  shadow">
        
        <div className="mb-2 ">
          <button
            onClick={() => setCurrentChart("FUTURES_SHORT")}
            className={`mr-2 rounded border px-4 py-2 ${
              currentChart === "FUTURES_SHORT" ? "bg-gray-300 text-black" : ""
            }`}
          >
            Futures - Short
          </button>
          <button
            onClick={() => setCurrentChart("FUTURES_LONG")}
            className={`mr-2 rounded border px-4 py-2 ${
              currentChart === "FUTURES_LONG" ? "bg-gray-300 text-black" : ""
            }`}
          >
            Futures - Long
          </button>
          <button
            onClick={() => setCurrentChart("OPTIONS_PUT")}
            className={`mr-2 rounded border px-4 py-2 ${
              currentChart === "OPTIONS_PUT" ? "bg-gray-300 text-black" : ""
            }`}
          >
            Options - Put
          </button>
          <button
            onClick={() => setCurrentChart("OPTIONS_CALL")}
            className={`mr-2 rounded border px-4 py-2 ${
              currentChart === "OPTIONS_CALL" ? "bg-gray-300 text-black" : ""
            }`}
          >
            Options - Call
          </button>
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
        {/* <div className="mb-10 mt-4 flex justify-center space-x-4 mb-10">
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
        </div> */}
      </div>
    </div>
  );
};

export default TemplateIdPage;

const poolData: Pool[] = [
  {
    id: "1",
    pool: "PRNT/WXDC",
    TVL: 57580,
    volume24h: 496.34,
    volume7D: 2660,
  },
  {
    id: "2",
    pool: "XTT/XSP",
    TVL: 42120,
    volume24h: 0,
    volume7D: 0,
  },
  {
    id: "3",
    pool: "BIC/WXDC",
    TVL: 4640,
    volume24h: 0,
    volume7D: 1,
  },
  {
    id: "4",
    pool: "PRNT/BIC",
    TVL: 1900,
    volume24h: 0,
    volume7D: 0,
  },
  {
    id: "5",
    pool: "BIC/XSP",
    TVL: 1150,
    volume24h: 0,
    volume7D: 0,
  },
  {
    id: "6",
    pool: "BIC/WXDC",
    TVL: 86117,
    volume24h: 0,
    volume7D: 0,
  },
  {
    id: "7", // id to be address
    pool: "WXDC/xUSDT",
    TVL: 62371,
    volume24h: 34.23,
    volume7D: 24976,
  },
  {
    id: "8",
    pool: "BIC/xUSDT",
    TVL: 56485,
    volume24h: 0,
    volume7D: 0,
  },
  {
    id: "9",
    pool: "BIC/xUSDT",
    TVL: 24849,
    volume24h: 0,
    volume7D: 0,
  },
  {
    id: "10",
    pool: "XSP/WXDC",
    TVL: 21514,
    volume24h: 1.13,
    volume7D: 4647,
  },
];
