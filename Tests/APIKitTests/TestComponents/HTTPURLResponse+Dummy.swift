import Foundation

extension HTTPURLResponse {
    static var dummy: HTTPURLResponse {
        return HTTPURLResponse(
            url: URL(string: "https://example.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil)!
    }
}
