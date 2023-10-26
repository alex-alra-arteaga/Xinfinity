import React, { useEffect, useState } from 'react';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faMinusCircle, faPlusCircle, faRightFromBracket, faTimesCircle } from '@fortawesome/free-solid-svg-icons';
import { poolData } from '@/lib/constants';

interface StrategySidebarProps {
    id: string;
  }
  

const StrategySidebar: React.FC<StrategySidebarProps> = ({id}) => {

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
            <div className="w-64 bg-gradient-to-b from-black via-indigo-900 items-center justify-center to-black p-4 overflow-y-auto shadow-lg h-3/4  rounded border border-gray-300 mt-36">
                <h2 className="text-xl font-semibold mb-6 text-white">{currentPoolName}</h2>
                <div className="flex flex-col space-y-4 ">
                    <button onClick={handleSellFuture} className="flex items-center bg-purple-500 hover:bg-purple-700 text-white py-2 px-4 rounded">
                        <FontAwesomeIcon icon={faMinusCircle} className="mr-2"/>
                        Sell Future
                    </button>
                    <button onClick={handleBuyFuture} className="flex items-center bg-green-500 hover:bg-green-700 text-white py-2 px-4 rounded">
                        <FontAwesomeIcon icon={faPlusCircle} className="mr-2"/>
                        Buy Future
                    </button>
                    <button onClick={handleCloseFuture} className="flex items-center bg-orange-500 hover:bg-orange-700 text-white py-2 px-4 rounded">
                    <FontAwesomeIcon icon={faRightFromBracket} className="mr-2"/>
                        Close Future
                    </button>
                    <button onClick={handleSellOption} className="flex items-center bg-purple-500 hover:bg-purple-700 text-white py-2 px-4 rounded">
                        <FontAwesomeIcon icon={faMinusCircle} className="mr-2"/>
                        Sell Option
                    </button>
                    <button onClick={handleBuyOption} className="flex items-center bg-green-500 hover:bg-green-700 text-white py-2 px-4 rounded">
                        <FontAwesomeIcon icon={faPlusCircle} className="mr-2"/>
                        Buy Option
                    </button>
                    <button onClick={handleCloseOption} className="flex items-center bg-orange-500 hover:bg-orange-700 text-white py-2 px-4 rounded">
                    <FontAwesomeIcon icon={faRightFromBracket} className="mr-2"/>
                        Close Option
                    </button>
                </div>
            </div>
            <div className="flex-grow bg-blue-50 p-4 bg-gradient-to-b from-black via-indigo-900 to-black">
                {/* Your chart component goes here */}
                <h2 className="text-xl font-semibold mb-4">Chart</h2>
                {/* Add other chart details below */}
            </div>
        </div>
    );
}

export default StrategySidebar;
