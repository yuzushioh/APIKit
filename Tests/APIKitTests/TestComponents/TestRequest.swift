import Foundation
import APIKit

struct TestRequest: Request {
    var absoluteURL: URL? {
        let urlRequest = try? buildURLRequest()
        return urlRequest?.url
    }

    // MARK: Request
    typealias Response = TestResponse

    init(baseURL: String = "https://example.com", path: String = "/", method: HTTPMethod = .get, parameters: Any? = [:], headerFields: [String: String] = [:], interceptURLRequest: @escaping (URLRequest) throws -> URLRequest = { $0 }) {
        self.baseURL = URL(string: baseURL)!
        self.path = path
        self.method = method
        self.parameters = parameters
        self.headerFields = headerFields
        self.interceptURLRequest = interceptURLRequest
    }

    let baseURL: URL
    let method: HTTPMethod
    let path: String
    let parameters: Any?
    let headerFields: [String: String]
    let interceptURLRequest: (URLRequest) throws -> URLRequest

    func intercept(urlRequest: URLRequest) throws -> URLRequest {
        return try interceptURLRequest(urlRequest)
    }
}

struct TestResponse: Response {
    typealias DataParser = JSONDataParser
    
    static var dataParser: JSONDataParser {
        return JSONDataParser(readingOptions: [])
    }

    let json: Any

    init(parsedData: JSONDataParser.Parsed, urlResponse: HTTPURLResponse) throws {
        json = parsedData
    }
}
