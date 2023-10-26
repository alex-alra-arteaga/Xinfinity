"use client"

import "@rainbow-me/rainbowkit/styles.css";

import {
  RainbowKitProvider as _RainbowKitProvider,
  getDefaultWallets,
  midnightTheme,
  darkTheme,
} from "@rainbow-me/rainbowkit";
import { RainbowKitSiweNextAuthProvider, GetSiweMessageOptions } from "@rainbow-me/rainbowkit-siwe-next-auth";
import { WagmiConfig, configureChains, createConfig, mainnet } from "wagmi";
import { xdc } from "wagmi/chains";
import { publicProvider } from "wagmi/providers/public";

const { chains, publicClient } = configureChains(
  [
    // process.env.NEXT_PUBLIC_MODEDEPLOY == "production"
    //   ? polygon
    //   : sepolia,
    xdc
  ],
  // [alchemyProvider({ apiKey: process.env.ALCHEMY_ID ?? "" }), publicProvider()]
  [publicProvider()]
);

const { connectors } = getDefaultWallets({
  appName: "Xinfinity DEX",
  projectId: "7a76c4b8cb7a09d36cf52b4406bb3f7c",
  chains,
});

const wagmiConfig = createConfig({
  autoConnect: true,
  connectors,
  publicClient,
  // consider using a websocket provider for faster updates
});

const getSiweMessageOptions: GetSiweMessageOptions = () => ({
  statement: 'Register to Xinfinity DEX',
});

export default function RainbowKitProvider({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <WagmiConfig config={wagmiConfig}>
        <RainbowKitSiweNextAuthProvider getSiweMessageOptions={getSiweMessageOptions}>
          <_RainbowKitProvider
            chains={chains}
            modalSize="compact"
            theme={midnightTheme({
              accentColor: "#212A3E",
              accentColorForeground: "#FFFFFF",
            })}>
            {children}
          </_RainbowKitProvider>
        </RainbowKitSiweNextAuthProvider>
    </WagmiConfig>
  );
}
