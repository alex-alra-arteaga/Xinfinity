import { Icons } from "@/components/Icons";
import Link from "next/link";
import UserAuthForm from "./UserAuthForm";
import { FC, useMemo } from "react";
import { useToast } from "@/hooks/use-toast";
import { userCredentialsSignUp } from "@/modules/user/services/auth";
import { SubmitHandler } from "react-hook-form";
import UserSignUpForm from "./UserSignUpForm";

interface Props {
  mode?: "sigIn" | "signup";
}

const SignIn: FC<Props> = ({ mode = "sigIn" }) => {
  const { linkText, otherPage, buttonText } = useMemo(() => {
    const isSignIn = mode === "sigIn";
    return {
      otherPage: isSignIn ? "/sign-up" : "/sign-in",
      linkText: isSignIn
        ? "don't have an account?"
        : "already have an account?",
      buttonText: isSignIn ? "sign up" : "sign in",
    };
  }, [mode]);

  return (
    <div className="container mx-auto flex w-full flex-col justify-center space-y-6 sm:w-[400px]">
      <div className="flex flex-col space-y-2 text-center">
        <Icons.logo className="mx-auto h-6 w-6" />
        <h1 className="text-2xl font-semibold tracking-tight">Welcome back</h1>
        <p className="mx-auto max-w-xs text-sm">
          By continuing, you are setting up an account and agree to our User
          Agreement and Privacy Policy.
        </p>
      </div>

      {mode === "sigIn" ? <UserAuthForm /> : <UserSignUpForm />}

      <p className="px-8 text-center text-sm text-muted-foreground">
        {linkText}
        <Link
          href={otherPage}
          className="hover:text-brand text-sm underline underline-offset-4"
        >
          {buttonText}
        </Link>
      </p>
    </div>
  );
};

export default SignIn;
