"use client";

import {
  Sheet,
  SheetContent,
  SheetDescription,
  SheetHeader,
  SheetTitle,
  SheetTrigger,
} from "@/components/ui/sheet";
import { useSession } from "next-auth/react";
import { ConnectButton } from "@rainbow-me/rainbowkit";

export function SheetNav() {
  const { data } = useSession();

  return (
    <div>
      <Sheet>
        <SheetTrigger className="transform cursor-pointer rounded-md border-2 border-violet-400 bg-gray-800 p-3 font-bold text-white transition-transform hover:scale-105 hover:bg-violet-400 hover:text-black">
          Open
        </SheetTrigger>
        <SheetContent side="left">
          <SheetHeader>
            {!data && (
              <div>
              <div>Connect the wallet to signIn and start Operating</div>
              <ConnectButton />
              </div>
            )}
            {data && (<> <SheetTitle>Welcome {data?.user.address}</SheetTitle>
            <SheetDescription>
             This is your dashboard, to see and manage your profile
            </SheetDescription></>)}
          
          </SheetHeader>
        </SheetContent>
      </Sheet>
    </div>
  );
}
