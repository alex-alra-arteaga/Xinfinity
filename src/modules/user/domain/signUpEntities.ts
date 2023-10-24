import { NextApiRequest } from "next"
import {z} from "zod"

export const SignUpRouteTyping = z.object({
    email: z.string().email(),
    password: z.string().min(4)
})

export interface SignUpApiReq extends NextApiRequest {
    body: z.infer<typeof SignUpRouteTyping>

}

export const validateReqBody = (body: any) => SignUpRouteTyping.safeParse(body)