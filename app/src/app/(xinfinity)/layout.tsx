import DexNavbar from "@/components/DexNavbar";
import { Navbar } from "./_components/navbar";
import { SheetNav } from "./_components/sheet";

const DashboardLayout = ({ children }: { children: React.ReactNode }) => {
  return (
    <div className="h-full">
      <DexNavbar/>
      <main className="h-full">{children}</main>
    </div>
  );
};

export default DashboardLayout;
