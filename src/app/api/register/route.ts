
import { validateReqBody } from "@/modules/user/domain/signUpEntities";
import { userCredentialsSignUp } from "@/modules/user/services/auth";
import { NextResponse } from "next/server";

export async function POST(req: Request) {

    try {
        const request = await req.json()
        const { success } = validateReqBody(request)
    
        if(!success) throw new Error("Wrong req params")
        const {email, password} = request
        await userCredentialsSignUp(email, password)

        return NextResponse.json(
            {message: "user created"},
            {status: 200}
        )
    } catch (error: any) {
        return NextResponse.json(
            {message: error?.message || "something went wrong"},
            {status: 500}
        )
    }
}   