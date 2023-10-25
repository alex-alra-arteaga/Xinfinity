"use client";

import {
  Sheet,
  SheetContent,
  SheetDescription,
  SheetHeader,
  SheetTitle,
  SheetTrigger,
} from "@/components/ui/sheet";

export function SheetNav() {
  return (
    <div>
      <Sheet>
        <SheetTrigger className="transform cursor-pointer rounded-md border-2 border-violet-400 bg-gray-800 p-3 font-bold text-white transition-transform hover:scale-105 hover:bg-violet-400 hover:text-black">
          Open
        </SheetTrigger>
        <SheetContent side="left">
          <SheetHeader>
            <SheetTitle>Are you sure absolutely sure?</SheetTitle>
            <SheetDescription>
              This action cannot be undone. This will permanently delete your
              account and remove your data from our servers.
            </SheetDescription>
          </SheetHeader>
        </SheetContent>
      </Sheet>
    </div>
  );
}
