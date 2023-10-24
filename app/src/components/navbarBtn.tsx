"use client";

import { Link } from "lucide-react";
import { buttonVariants } from "./ui/button";
import { useRouter } from "next/router";
import { ConnectButton } from "@rainbow-me/rainbowkit";

export const NavbarBtn = () => {
  const router = useRouter();

  const currentPath = router.pathname as string;

  return (
    <>
      {currentPath !== "/Landing" && (
        <ConnectButton/>
      )}
    </>
  );
};
