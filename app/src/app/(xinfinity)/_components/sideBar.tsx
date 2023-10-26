import React, { useEffect, useState } from "react";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import {
  faMinusCircle,
  faPlusCircle,
  faRightFromBracket,
  faTimesCircle,
} from "@fortawesome/free-solid-svg-icons";
import { poolData } from "@/lib/constants";

interface StrategySidebarProps {
  id: string;
}

const StrategySidebar: React.FC<StrategySidebarProps> = ({ id }) => {
  const [currentPoolName, setCurrentPoolName] = useState<string>("");
  useEffect(() => {
    console.log("id", id);
    const pool = poolData.find((p) => p.id === id);
    if (pool) {
      setCurrentPoolName(pool.pool);
    }
  }, []);

  // Handlers for the new functionalities
  const handleSellFuture = () => {
    // functionality for "sell future" here
  };

  const handleBuyFuture = () => {
    // unctionality for "buy future" here
  };

  const handleCloseFuture = () => {
    // functionality for "exercise/close future" here
  };

  const handleSellOption = () => {
    // functionality for "sell option" here
  };

  const handleBuyOption = () => {
    // functionality for "buy option" here
  };

  const handleCloseOption = () => {
    //  functionality for "exercise/close option" here
  };

  return (
    <div className="flex h-full">
      <div className="mt-36 h-3/4 w-64 items-center justify-center overflow-y-auto rounded border border-gray-300 bg-gradient-to-b from-black  via-indigo-900 to-black p-4 shadow-lg">
        <h2 className="mb-6 text-xl font-semibold text-white ">
          {currentPoolName}
        </h2>
        <h3>Futures</h3>
        <div className="flex flex-col space-y-4 mt-3 ">
          <button
            onClick={handleSellFuture}
            className="flex items-center rounded bg-purple-500 px-4 py-2 text-white hover:bg-purple-700"
          >
            <FontAwesomeIcon icon={faMinusCircle} className="mr-2" />
            Sell
          </button>
          <button
            onClick={handleBuyFuture}
            className="flex items-center rounded bg-green-500 px-4 py-2 text-white hover:bg-green-700"
          >
            <FontAwesomeIcon icon={faPlusCircle} className="mr-2" />
            Buy
          </button>
          <button
            onClick={handleCloseFuture}
            className="flex items-center rounded bg-orange-500 px-4 py-2 text-white hover:bg-orange-700"
          >
            <FontAwesomeIcon icon={faRightFromBracket} className="mr-2" />
            Close
          </button>
          <h3>Options</h3>
          <button
            onClick={handleSellOption}
            className="flex items-center rounded bg-purple-500 px-4 py-2 text-white hover:bg-purple-700"
          >
            <FontAwesomeIcon icon={faMinusCircle} className="mr-2" />
            Sell
          </button>
          <button
            onClick={handleBuyOption}
            className="flex items-center rounded bg-green-500 px-4 py-2 text-white hover:bg-green-700"
          >
            <FontAwesomeIcon icon={faPlusCircle} className="mr-2" />
            Buy
          </button>
          <button
            onClick={handleCloseOption}
            className="flex items-center rounded bg-orange-500 px-4 py-2 text-white hover:bg-orange-700"
          >
            <FontAwesomeIcon icon={faRightFromBracket} className="mr-2" />
            Close
          </button>
        </div>
      </div>
      <div className="grow bg-blue-50 bg-gradient-to-b from-black via-indigo-900 to-black p-4">
        {/* Your chart component goes here */}
        <h2 className="mb-4 text-xl font-semibold">Chart</h2>
        {/* Add other chart details below */}
      </div>
    </div>
  );
};

export default StrategySidebar;
