import { z, ZodTypeAny } from "zod";

type ValidatedCallbackOptions<
  CallbackInput,
  OutputValidation extends ZodTypeAny,
  InputValidation extends ZodTypeAny
> = {
  outputValidation?: OutputValidation;
  inputValidation?: InputValidation;
  callback: InputValidation extends ZodTypeAny
    ? (input: z.infer<InputValidation>) => any
    : (input: CallbackInput) => any;
};

// @dev Esta funcion toma una funcion a ejecutar "callback",
// y se puede especificar que parametros ha de recibir o retornar
// lo que mejora radicalmente la validez del tipado en toda nuestra aplicación
export function validatedCallback<
  CallbackInput,
  OutputValidation extends ZodTypeAny,
  InputValidation extends ZodTypeAny
>(
  options: ValidatedCallbackOptions<
    CallbackInput,
    OutputValidation,
    InputValidation
  >
) {
  return async function (
    input: CallbackInput
  ): Promise<z.infer<OutputValidation>> {
    // en el caso de que una de las validaxiones sea null se ejecutará
    // este codigo arbitrario
    const passthrough = { parse: (i: any) => i };
    const { inputValidation, callback, outputValidation } = options;

    const validatedInput = (inputValidation ?? passthrough).parse(input);
    const outputs = await callback(validatedInput);
    const parsedOutput = (outputValidation ?? passthrough).parse(outputs);
    return parsedOutput;
  };
}
