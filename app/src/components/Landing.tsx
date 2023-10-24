export default async function Landing() {
    let xdcPrice;
    try {
      const priceResponse = await fetch(
        ` https://api.coingecko.com/api/v3/simple/price?ids=xdce-crowd-sale&vs_currencies=usd`
      );
      const jsonData = await priceResponse.json();
      xdcPrice = jsonData["xdce-crowd-sale"].usd.toFixed(4);
    } catch (error) {
      console.log("error", error);
    }
  
    return (
      <div className="flex min-h-screen flex-col items-center justify-center bg-gradient-to-b from-black via-indigo-900 to-black p-4 text-white">
        {/* Main Content */}
        <div className="mt-20 flex w-full max-w-5xl items-center justify-between">
          <div className="px-4">
            <h1 className="text-shadow mb-4 text-5xl font-extrabold leading-tight">
              Top <br /> Decentralized <br /> Crypto Exchange
            </h1>
            <p className="text-shadow mb-4 mt-2 text-lg">
              Trade diverse crypto assets and perpetual markets with unmatched
              rebates in our cutting-edge decentralized platform
            </p>
            <button className="rounded-lg bg-indigo-500 px-6 py-2 text-white shadow-lg hover:bg-indigo-600">
              Start Trading now
            </button>
          </div>
  
          {/* Conversion Box */}
          <div className="rounded-xl bg-gradient-to-br from-black to-indigo-900 p-8 px-4 shadow-lg">
            <div className="mb-4 flex space-x-6">
              <div className="flex-1">
                <div className="mb-2 flex items-center">
                  <span className="mr-2 text-lg">$ USD</span>
                  <span className="text-md font-semibold"></span>
                </div>
                <input
                  className="w-full rounded-lg border border-gray-700 bg-gray-800 px-4 py-2 text-white focus:outline-none"
                  value={`${xdcPrice}`}
                />
              </div>
              <div className="mx-2 mt-4 text-3xl">⇌</div>
              <div className="flex-1">
                <div className="mb-2 flex items-center">
                  <span className="mr-2 text-lg">🔵 XDC</span>
                </div>
                <input
                  className="w-full rounded-lg border border-gray-700 bg-gray-800 px-4 py-2 text-white focus:outline-none"
                  value="1"
                />
              </div>
            </div>
            <button className="w-full rounded-lg bg-green-500 px-4 py-2 text-white shadow-lg hover:bg-green-600">
              Get XDC
            </button>
          </div>
        </div>
  
        {/* Features */}
        <div className="mt-20 flex w-full max-w-5xl justify-center space-x-8">
          {["🔗 Interoperable", "🔒 Secure", "⛽ Gas Free", "⚡ Fast"].map(
            (feature, index) => (
              <div
                key={index}
                className="flex w-48 flex-col items-center rounded-xl bg-gradient-to-br from-black to-indigo-900 p-6 shadow-md"
              >
                <span className="mb-2 block text-3xl">{feature.slice(0, 2)}</span>
                <span className="text-lg font-semibold">{feature.slice(2)}</span>
              </div>
            )
          )}
        </div>
      </div>
    );
  }
  