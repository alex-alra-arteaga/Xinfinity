import Link from "next/link";
import { getAuthSession } from "@/lib/auth/auth";
import { Icons } from "./Icons";
import { ConnectButton } from "@rainbow-me/rainbowkit";

const Navbar = async () => {
  const session = await getAuthSession();
  return (
    <div className="fixed inset-x-0 top-0 z-[10] h-fit border-b border-zinc-300 bg-black py-2">
      <div className="container mx-auto flex h-full max-w-7xl items-center justify-between gap-2">
        {/* logo */}
        <Link href="/" className="flex items-center gap-2">
          <Icons.logo className="h-8 w-8 sm:h-6 sm:w-6" />
          <h2 className="font-large hidden text-sm text-white md:block">
            Xinfinity
          </h2>
        </Link>

        {/* actions */}
        {/* {session?.user ? (
          <p className="text-white">logged In as {session.user.address}</p>
        ) : (
          <ConnectButton/>
        )} */}
        <ConnectButton/>
      </div>
    </div>
  );
};

export default Navbar;
