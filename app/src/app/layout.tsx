import Navbar from "@/components/Navbar";
import "../styles/globals.css";
import { Inter } from "next/font/google";
import { Toaster } from "@/components/ui/toaster";
import RainbowKitProvider from "../components/providers/raimbow-kit";
import { Footer } from "@/components/Footer";
import Providers from "./providers";

const inter = Inter({ subsets: ["latin"] });

export const metadata = {
  title: "Xinfinity",
  description: "Futures and Options Perpetual DEX on XDC",
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body className={inter.className}>
        <Providers>
          <RainbowKitProvider>
            {children}
            <Footer />
            <Toaster />
          </RainbowKitProvider>
        </Providers>
      </body>
    </html>
  );
}
