"use client";
import { useEffect, useRef } from "react";
import { Pool } from "../../_components/pools";
import Chart from "chart.js/auto";

export default async function TemplateIdPage({
  params,
}: {
  params: { id: string };
}) {
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
  const mockVolumeData = [
    520, // Volume at 1h ago
    515, // Volume at 2h ago
    530, // Volume at 3h ago
    540, // Volume at 4h ago
    545, // ...
    560,
    562,
    555,
    558,
    559,
    570,
    580,
    582,
    585,
    586,
    590,
    595,
    600,
    605,
    610,
    612,
    615,
    620,
    625, // Volume at 24h ago
  ];

  return (
    <div>
      <h2>Volume in the last 24h for {params.id}</h2>
    </div>
  );
}
