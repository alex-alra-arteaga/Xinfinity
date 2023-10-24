import { db } from "@/lib/db";
import { PrismaAdapter } from "@next-auth/prisma-adapter";
import { NextAuthOptions, getServerSession } from "next-auth";
import EmailProvider from "next-auth/providers/email";
import CredentialsProvider from "next-auth/providers/credentials";
import { PrismaClient } from "@prisma/client";
import { SiweMessage } from "siwe";
import { getCsrfToken } from "next-auth/react";
const prisma = new PrismaClient();

/**
 * @dev Two main ways to sign in:
 * 1. Credentials -> sign in with Ethereum address and signature
 *    - authorize
 *    - signIn callback
 *    - token callback
 *    - session callback
 * 2. Email -> sign in with email and magic link
 *    - click link
 *    - sendVerificationRequest
 *      -  just on click signIn callback target
 *    - token callback
 */

export const authOptions: NextAuthOptions = {
  adapter: PrismaAdapter(prisma),
  session: {
    strategy: "jwt",
  },
  pages: {
    signIn: "/sign-in",
    // error: "/sign-in/error"
  },
  providers: [
    CredentialsProvider({
      name: "Ethereum",
      type: "credentials",
      credentials: {
        message: {
          label: "Message",
          type: "text",
          placeholder: "0x0",
        },
        signature: {
          label: "Signature",
          type: "text",
          placeholder: "0x0",
        },
      },
      authorize: async (credentials, req) => {
        try {
          const siwe = new SiweMessage(
            JSON.parse(credentials?.message || "{}") as Partial<SiweMessage>
          );
          const nextAuthUrl = new URL(process.env.NEXTAUTH_URL ?? "");
          // let csrfToken = await getCsrfToken({ req }); // ! changed to req.body.csrfToken
          let csrfToken = req?.body?.csrfToken;
          const fields = await siwe.verify({
            signature: credentials?.signature || "",
            domain: nextAuthUrl.host,
            nonce: csrfToken,
          });
          // Check if user exists
          let user = await prisma.user.findUnique({
            where: {
              address: fields.data.address,
            },
          });
          // Create new user if doesn't exist
          if (!user) {
            user = await prisma.user.create({
              data: {
                address: fields.data.address,
                emailVerified: new Date(),
              },
            });
            // create account
            await prisma.account.create({
              data: {
                userId: user.id,
                type: "credentials",
                provider: "Ethereum",
                providerAccountId: fields.data.address,
              },
            });
          }
          return {
            id: user.id,
            address: fields.data.address,
          };
        } catch (error) {
          console.error({ error });
          return null;
        }
      },
    }),
  ],
  /**
   * @dev when using credentials, authorize first than signIn callback, but when using magik link / email, the signIn callback first
   */
  callbacks: {
    async signIn({ user }) {
      /**
       * @dev WEB·_NATIVE logic done in the authorize function of credentials Provider
       */
      return true;
    },
    async session({ token, session }) {
      if (token) {
        session.user.id = token.id;
        session.user.name = token.name;
        session.user.email = token.email;
        session.user.image = token.picture;
        session.user.username = token.username;
        session.user.address = token.address;
      }
      return session;
    },
    jwt: async (
      // Callback whenever JWT created (i.e. at sign in)
      { token, user }
    ) => {
      if (user) {
      }
      return token;
    },
  },
};


export const getAuthSession = () => getServerSession(authOptions);
