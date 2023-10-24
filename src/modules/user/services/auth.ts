"use server";

import { db } from "@/lib/db";
import { hashPassword } from "@/lib/hash";

export const userCredentialsSignUp = async (
  email: string,
  password: string
) => {
  const user = await db.user.findUnique({ where: { email } });

  if (user) throw new Error("User already exist");

  await db.user.create({
    data: {
      email: email,
      password: await hashPassword(password),
    },
  });

  return true;
};
