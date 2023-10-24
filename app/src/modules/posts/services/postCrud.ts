"use server";

import { getCurrentAuthedUser } from "@/lib/auth/session";
import { db } from "@/lib/db";
import { UnAuthorizedError } from "@/lib/typesafety/errors";
import { validatedCallback } from "@/lib/typesafety/validateCallback";
import { createPostDto, getPostsOutput } from "../domain/createpostDto";
import { z } from "zod";

export const createPost = validatedCallback({
  inputValidation: createPostDto,
  callback: async (inputs) => {
    const authedUser = await getCurrentAuthedUser();

    if (!authedUser) throw new UnAuthorizedError();
    const { content, description, title } = inputs;

    await db.post.create({
      data: {
        content,
        description,
        title,
        userId: authedUser.id,
      },
    });
    return true;
  },
});

export const getPosts = validatedCallback({
  inputValidation: z.object({
    page: z.number(),
    limit: z.number(),
  }),
  callback: async (inputs) => {
    const posts = await db.post.findMany({
      skip: inputs.page,
      take: inputs.limit,
      include: {
        User: {
          select: {
            email: true,
          },
        },
      },
    });

    return posts;
  },
  outputValidation: getPostsOutput,
});
