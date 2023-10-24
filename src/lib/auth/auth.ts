import { db } from "@/lib/db";
import { nanoid } from "nanoid";
import { PrismaAdapter } from "@next-auth/prisma-adapter";
import { NextAuthOptions, getServerSession } from "next-auth";
import GoogleProvider from "next-auth/providers/google";
import CredentialsProvider from "next-auth/providers/credentials";
import { isPasswordValid } from "@/lib/hash";

export const authOptions: NextAuthOptions = {
  adapter: PrismaAdapter(db),
  session: {
    strategy: "jwt",
  },
  pages: {
    signIn: "/sign-in",
  },
  providers: [
    GoogleProvider({
      clientId: process.env.GOOGLE_CLIENT_ID!,
      clientSecret: process.env.GOOGLE_CLIENT_SECRET!,
    }),
    CredentialsProvider({
      name: "mail",
      credentials: {
        mail: {
          label: "mail",
          type: "text",
          placeholder: "username",
        },
        password: {
          label: "pass",
          type: "text",
          placeholder: "your mail",
        },
      },
      async authorize(credentials) {
        try {
          const user = await db.user.findUnique({
            where: { email: credentials?.mail },
          });

          if (!user) {
            return null;
          }

          const isPasswordCorrect = await isPasswordValid(
            credentials?.password!,
            user.password!
          );

          if (!isPasswordCorrect) {
            return null;
          }

          return {
            id: user.id,
            username: user.username,
          };
        } catch (error) {
          return null;
        }
      },
    }),
  ],
  callbacks: {
    async session({ token, session }) {
      if (token) {
        session.user.id = token.id;
        session.user.name = token.name;
        session.user.email = token.email;
        session.user.image = token.picture;
        session.user.username = token.username;
      }

      return session;
    },

    async jwt({ token, user }) {
      const dbUser = await db.user.findFirst({
        where: {
          email: token.email,
        },
      });

      if (!dbUser) {
        token.id = user!.id;
        return token;
      }

      if (!dbUser.username) {
        await db.user.update({
          where: {
            id: dbUser.id,
          },
          data: {
            username: nanoid(10),
          },
        });
      }

      return {
        id: dbUser.id,
        name: dbUser.username,
        email: dbUser.email,
        username: dbUser.username,
      };
    },
    redirect() {
      return "/";
    },
  },
};

export const getAuthSession = () => getServerSession(authOptions);
