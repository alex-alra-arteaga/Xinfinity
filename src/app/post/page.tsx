"use client";

import { buttonVariants } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { createPost } from "@/modules/posts/services/postCrud";
import { createPostDto } from "@/modules/posts/domain/createpostDto";
import { useForm } from "react-hook-form";
import { z } from "zod";
import { useToast } from "@/hooks/use-toast";

type createPostInputParams = z.infer<typeof createPostDto>;

function Page({}) {
  const { register, handleSubmit } = useForm<createPostInputParams>();
  const { toast } = useToast();

  const onSubmit = async (data: createPostInputParams) => {
    try {
      await createPost(data);
      toast({
        title: "post created",
        content: "post created succesfully",
      });
    } catch (error: any) {
      toast({
        title: "error",
        content: error?.message ?? "something went wrong",
      });
    }
  };

  return (
    <div className="m-0-auto h-full min-h-[80vh] p-10 py-[20vh]">
      <h1>Create post</h1>

      <form onSubmit={handleSubmit(onSubmit)} className="flex flex-col gap-2">
        <Input
          type="text"
          placeholder="post title"
          {...register("title", { required: true })}
        />
        <Input
          type="text"
          placeholder="post description"
          {...register("description", { required: true })}
        />
        <Input
          type="text"
          placeholder="content"
          {...register("content", { required: true })}
        />

        <Input type="submit" className={buttonVariants()} />
      </form>
    </div>
  );
}

export default Page;
