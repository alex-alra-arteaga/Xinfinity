"use client"

import { Navbar } from "./_components/navbar";
import { SheetNav } from "./_components/sheet";

const DashboardLayout = ({ children }: { children: React.ReactNode }) => {
  return (
    <div className="h-full">
      <div className="fixed inset-y-0 z-50 h-[80px] w-full md:pl-56">
        <Navbar />
      </div>
      <div className="fixed inset-y-0 z-50 hidden h-full w-56 flex-col md:flex">
        <SheetNav />
      </div>
      <main className="h-full">{children}</main>
    </div>
  );
};

export default DashboardLayout;
