import Foundation

/// `FormURLEncodedResponse` protocol represents form-urlencoded response.
public protocol FormURLEncodedResponse: Response {
    /// The string encoding of the data.
    static var encoding: String.Encoding { get }
    
    /// Returns instance from form-urlencoded body `[String: Any]`
    /// and header `HTTPURLResponse`.
    init(form: [String: Any], urlResponse: HTTPURLResponse) throws
}

public extension FormURLEncodedResponse {
    static var contentType: String? {
        return "application/x-www-form-urlencoded"
    }
    
    static var encoding: String.Encoding {
        return .utf8
    }
    
    init(data: Data, urlResponse: HTTPURLResponse) throws {
        let form = try URLEncodedSerialization.object(
            from: data,
            encoding: Self.encoding)
        
        try self.init(form: form, urlResponse: urlResponse)
    }
}
