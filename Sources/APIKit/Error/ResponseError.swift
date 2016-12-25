import Foundation

/// `ResponseError` represents a common error that occurs while getting `Request.Response`
/// from raw result tuple `(Data?, URLResponse?, Error?)`.
public enum ResponseError: Error {
    /// Indicates the session adapter returned `URLResponse` that fails to down-cast to `HTTPURLResponse`.
    case nonHTTPURLResponse(URLResponse?)
}
