import { z } from "zod";

export const createPostDto = z.object({
  title: z.string(),
  description: z.string(),
  content: z.string(),
});

export const getPostsOutput = z
  .object({
    id: z.string(),
    userId: z.string(),
    title: z.string(),
    description: z.string(),
    content: z.string(),
  })
  .array();
