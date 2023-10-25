"use client"
import { Pools } from "../_components/pools";

export default function Home() {
  return (
    <div className="flex h-screen items-center justify-center bg-gradient-to-b from-black via-indigo-900 to-black p-4 text-white ">
      <div className="h-3/4 w-full max-w-6xl overflow-auto rounded border border-gray-300 p-10 shadow">
        <Pools />
      </div>
    </div>
  );
}
