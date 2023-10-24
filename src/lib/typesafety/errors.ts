export class NotFounderror extends Error {
  constructor(message = "content not found") {
    super(message);
    this.name = "Not found Error";
  }
}

export class UnAuthorizedError extends Error {
  constructor(message = "Unauthorized") {
    super(message);
    this.name = "Unauthorized error";
  }
}
