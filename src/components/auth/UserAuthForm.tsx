"use client";

import { cn } from "@/lib/utils";
import { signIn } from "next-auth/react";
import * as React from "react";
import { FC } from "react";
import { Button, buttonVariants } from "../ui/button";
import { Icons } from "../Icons";
import { useToast } from "@/hooks/use-toast";
import { SubmitHandler, useForm } from "react-hook-form";

interface UserAuthFormProps extends React.HTMLAttributes<HTMLDivElement> {}

type Inputs = {
  email: string;
  password: string;
};

const UserAuthForm: FC<UserAuthFormProps> = ({ className, ...props }) => {
  const { toast } = useToast();
  const [isLoading, setIsLoading] = React.useState<boolean>(false);

  const {
    register,
    handleSubmit,
    formState: { errors },
  } = useForm<Inputs>();

  const onSubmit: SubmitHandler<Inputs> = async (data) => {
    try {
      await signIn("credentials", {
        redirect: true,
        mail: data.email,
        password: data.password,
      });
      toast({
        title: "success",
        description: "logged in",
      });
    } catch (error: any) {
      toast({
        title: "error",
        description: error?.message || "something went wrong",
      });
    }
  };

  const loginWithGoogle = async () => {
    setIsLoading(true);

    try {
      await signIn("google");
    } catch (error) {
      toast({
        title: "Error",
        description: "There was an error logging in with Google",
        variant: "destructive",
      });
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <>
      <form onSubmit={handleSubmit(onSubmit)}>
        <div className="flex flex-col justify-center">
          <input
            placeholder="email"
            {...register("email", { required: true })}
          />
          {errors.email && <span>This field is required</span>}
          <input
            placeholder="password"
            type="password"
            {...register("password", { required: true })}
          />
          {errors.password && <span>This field is required</span>}
        </div>
        <input type="submit" className={buttonVariants()} />
      </form>

      <div className={cn("flex justify-center", className)} {...props}>
        <Button
          isLoading={isLoading}
          type="button"
          size="sm"
          className="w-full"
          onClick={loginWithGoogle}
          disabled={isLoading}
        >
          {isLoading ? null : <Icons.google className="mr-2 h-4 w-4" />}
          Google
        </Button>
      </div>
    </>
  );
};

export default UserAuthForm;
