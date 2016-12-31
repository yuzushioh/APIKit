import Foundation

/// `Response` protocol represents response of Web API.
public protocol Response {
    /// Indicates expected data format to parse.
    /// This value will also be used in `Accept` header field of HTTP request.
    static var contentType: String? { get }
    
    /// Returns instance from response body `Data` and header `HTTPURLResponse`.
    init(data: Data, urlResponse: HTTPURLResponse) throws
}

public extension Response {
    static var contentType: String? {
        return nil
    }
}
