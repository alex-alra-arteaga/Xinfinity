import { getServerSession } from "next-auth";

import { authOptions } from "./auth";

export function getSession() {
  return getServerSession(authOptions);
}

export async function getCurrentAuthedUser() {
  const session = await getSession();
  return session?.user;
}
