import Navbar from "./Navbar";

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
    <div>
    <Navbar />
    <div className="flex min-h-screen flex-col items-center justify-center bg-gradient-to-b from-black via-indigo-900 to-black p-4 text-white">
      {/* Main Content */}
      <div className="mt-20 flex w-full max-w-5xl items-center justify-between">
        <div className="px-4">
          <h1 className="mb-4 text-5xl font-extrabold leading-tight text-shadow-xl">
            First ever Futures and Options Perpetual DEX on any chain
          </h1>
          <p className="mb-4 mt-2 text-lg text-shadow">
            Trade diverse crypto assets on perpetual markets with the least liquidity fragmentation in Xinfinity DEX
          </p>
          <a href="/app">
            <button className="rounded-lg bg-indigo-500 px-6 py-2 text-white shadow-lg hover:bg-indigo-600">
              Launch App
            </button>
          </a>
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
                value={`${xdcPrice || "0,5"}`}
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
          <a href="/app">
            <button className="w-full rounded-lg bg-green-500 px-4 py-2 text-white shadow-lg hover:bg-green-600">
              Swap
            </button>
          </a>
        </div>
      </div>

      {/* Features */}
      <div className="mt-20 flex w-full max-w-5xl justify-center space-x-8">
        {["🔗 On XDC", "⛽ Options", "⚡ Futures"].map((feature, index) => (
          <div
            key={index}
            className="flex w-48 flex-col items-center rounded-xl bg-gradient-to-br from-black to-indigo-900 p-6 shadow-md"
          >
            <span className="mb-2 block text-3xl">{feature.slice(0, 2)}</span>
            <span className="text-lg font-semibold">{feature.slice(2)}</span>
          </div>
        ))}
      </div>
    </div>
    </div>
  );
}
