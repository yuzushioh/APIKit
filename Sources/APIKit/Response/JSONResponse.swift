import Foundation

/// `JSONResponse` protocol represents response of JSON API.
public protocol JSONResponse: Response {
    /// Options used when Creating JSON `Any` from response body `Data`.
    static var readingOptions: JSONSerialization.ReadingOptions { get }
    
    /// Returns instance from response body JSON `Any` and header `HTTPURLResponse`.
    init(json: Any, urlResponse: HTTPURLResponse) throws
}

public extension JSONResponse {
    static var readingOptions: JSONSerialization.ReadingOptions {
        return []
    }
    
    init(data: Data, urlResponse: HTTPURLResponse) throws {
        let json = try JSONSerialization.jsonObject(
            with: data,
            options: Self.readingOptions)

        try self.init(json: json, urlResponse: urlResponse)
    }
}
