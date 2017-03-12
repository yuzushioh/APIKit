import PlaygroundSupport
import Foundation
import APIKit

PlaygroundPage.current.needsIndefiniteExecution = true

//: Step 1: Define request protocol
protocol GitHubRequest: Request {}

extension GitHubRequest {
    var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }
}

//: Step 2: Define response protocol
protocol GitHubResponse: Response {}

extension GitHubResponse {
    static var parser: JSONDataParser {
        return JSONDataParser(readingOptions: [])
    }
}

//: Step 3: Create response model that conforms to the response protocol.
struct RateLimit: GitHubResponse {
    let count: Int
    let resetDate: Date

    init(data: RateLimit.Parser.Parsed, urlResponse: HTTPURLResponse) throws {
        guard
            let rootDictionary = data as? [String: Any],
            let rateDictionary = rootDictionary["rate"] as? [String: Any] else {
            throw ResponseError.unexpectedObject(data)
        }

        guard let count = rateDictionary["limit"] as? Int else {
            throw ResponseError.unexpectedObject(data)
        }

        guard let resetDateString = rateDictionary["reset"] as? TimeInterval else {
            throw ResponseError.unexpectedObject(data)
        }

        self.count = count
        self.resetDate = Date(timeIntervalSince1970: resetDateString)
    }
}

//: Step 3: Define request type conforming to created request protocol
// https://developer.github.com/v3/rate_limit/
struct GetRateLimitRequest: GitHubRequest {
    typealias Response = RateLimit

    var method: HTTPMethod {
        return .get
    }

    var path: String {
        return "/rate_limit"
    }
}

//: Step 4: Send request
let request = GetRateLimitRequest()

Session.send(request) { result in
    switch result {
    case .success(let rateLimit):
        print("count: \(rateLimit.count)")
        print("reset: \(rateLimit.resetDate)")

    case .failure(let error):
        print("error: \(error)")
    }
}
