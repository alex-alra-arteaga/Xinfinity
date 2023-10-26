import React, { useEffect, useState } from "react";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import {
  faMinusCircle,
  faPlusCircle,
  faRightFromBracket,
  faTimesCircle,
} from "@fortawesome/free-solid-svg-icons";
import { poolData } from "@/lib/constants";
import {StrategyType} from "../../../types/types";

interface StrategySidebarProps {
  id: string;
  strategyFn: (type: StrategyType) => void;
  currentStrategy: () => StrategyType;
}

const StrategySidebar: React.FC<StrategySidebarProps> = ({ id, strategyFn, currentStrategy }) => {
  const [currentPoolName, setCurrentPoolName] = useState<string>("");

  useEffect(() => {
    console.log("id", id);
    const pool = poolData.find((p) => p.id === id);
    if (pool) {
      setCurrentPoolName(pool.pool);
    }
  }, []);
  
  return (
    <div className="flex h-full">
      <div className="mt-36 h-3/4 w-64 items-center justify-center overflow-y-auto rounded border border-gray-300 bg-gradient-to-b from-black  via-indigo-900 to-black p-4 shadow-lg">
        <h2 className="mb-6 text-xl font-semibold text-white ">
          {currentPoolName}
        </h2>
        <h3 className="text-white">Futures</h3>
        <div className="flex flex-col space-y-4 mt-3 ">
          <button
            onClick={() => strategyFn(StrategyType.FUTURES_SHORT)}
            className={`flex items-center rounded px-4 py-2 text-white hover:bg-purple-700 ${currentStrategy() === StrategyType.FUTURES_SHORT ? "bg-purple-500 opacity-60" : "bg-purple-500"}`}
            >
            <FontAwesomeIcon icon={faMinusCircle} className="mr-2" />
            Sell
          </button>
          <button
            onClick={() => strategyFn(StrategyType.FUTURES_LONG)}
            className={`flex items-center rounded px-4 py-2 text-white hover:bg-green-700 ${currentStrategy() === StrategyType.FUTURES_LONG ? "bg-green-500 opacity-60" : "bg-green-500"}`}
            >
            <FontAwesomeIcon icon={faPlusCircle} className="mr-2" />
            Buy
          </button>
          <button
            onClick={() => strategyFn(StrategyType.CLOSE_FUTURE)}
            className={`${currentStrategy() === StrategyType.CLOSE_FUTURE ? "bg-orange-500 opacity-60" : ""} flex items-center rounded bg-orange-500 px-4 py-2 text-white hover:bg-orange-700`}
          >
            <FontAwesomeIcon icon={faRightFromBracket} className="mr-2" />
            Close
          </button>
          <h3 className="text-white">Options</h3>
          <button
            onClick={() => strategyFn(StrategyType.OPTIONS_PUT)}
            className={`flex items-center rounded px-4 py-2 text-white hover:bg-purple-700 ${currentStrategy() === StrategyType.OPTIONS_PUT ? "bg-purple-500 opacity-60" : "bg-purple-500"}`}
          >
            <FontAwesomeIcon icon={faMinusCircle} className="mr-2" />
            Sell
          </button>
          <button
            onClick={() => strategyFn(StrategyType.OPTIONS_CALL)}
            className={`flex items-center rounded px-4 py-2 text-white hover:bg-green-700 ${currentStrategy() === StrategyType.OPTIONS_CALL ? "bg-green-500 opacity-60" : "bg-green-500"}`}
            >
            <FontAwesomeIcon icon={faPlusCircle} className="mr-2" />
            Buy
          </button>
          <button
            onClick={() => strategyFn(StrategyType.CLOSE_OPTION)}
            className={`${currentStrategy() === StrategyType.CLOSE_OPTION ? "bg-orange-500 opacity-60" : "bg-orange-500"} flex items-center rounded px-4 py-2 text-white hover:bg-orange-700`}
          >
            <FontAwesomeIcon icon={faRightFromBracket} className="mr-2" />
            Close
          </button>
        </div>
      </div>
    </div>
  );
};

export default StrategySidebar;
