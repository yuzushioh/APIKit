import Foundation

/// `Response` protocol represents response of Web API.
public protocol Response {
    /// Returns instance from response body `Data` and header `HTTPURLResponse`.
    init(data: Data, urlResponse: HTTPURLResponse) throws
}
