var __defProp = Object.defineProperty;
var __name = (target, value) => __defProp(target, "name", { value, configurable: true });
const _HttpError = class _HttpError {
  /**
   * @param {number} status
   * @param {{message: string} extends App.Error ? (App.Error | string | undefined) : App.Error} body
   */
  constructor(status, body) {
    this.status = status;
    if (typeof body === "string") {
      this.body = { message: body };
    } else if (body) {
      this.body = body;
    } else {
      this.body = { message: `Error: ${status}` };
    }
  }
  toString() {
    return JSON.stringify(this.body);
  }
};
__name(_HttpError, "HttpError");
let HttpError = _HttpError;
const _Redirect = class _Redirect {
  /**
   * @param {300 | 301 | 302 | 303 | 304 | 305 | 306 | 307 | 308} status
   * @param {string} location
   */
  constructor(status, location) {
    this.status = status;
    this.location = location;
  }
};
__name(_Redirect, "Redirect");
let Redirect = _Redirect;
const _ActionFailure = class _ActionFailure {
  /**
   * @param {number} status
   * @param {T} [data]
   */
  constructor(status, data) {
    this.status = status;
    this.data = data;
  }
};
__name(_ActionFailure, "ActionFailure");
let ActionFailure = _ActionFailure;
function error(status, body) {
  if (isNaN(status) || status < 400 || status > 599) {
    throw new Error(`HTTP error status codes must be between 400 and 599 — ${status} is invalid`);
  }
  return new HttpError(status, body);
}
__name(error, "error");
function redirect(status, location) {
  if (isNaN(status) || status < 300 || status > 308) {
    throw new Error("Invalid status code");
  }
  return new Redirect(status, location.toString());
}
__name(redirect, "redirect");
new TextEncoder();
function fail(status, data) {
  return new ActionFailure(status, data);
}
__name(fail, "fail");
export {
  error as e,
  fail as f,
  redirect as r
};
