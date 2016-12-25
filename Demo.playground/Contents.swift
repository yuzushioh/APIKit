import PlaygroundSupport
import Foundation
import APIKit

PlaygroundPage.current.needsIndefiniteExecution = true

//: Step 1: Define request protocol.
protocol GitHubRequest: Request {

}

extension GitHubRequest {
    var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }
}

//: Step 2: Define response type conforms to response protocol.
struct RateLimitResponse: JSONResponse {
    struct DecodeError: Error {
        let json: Any
        let description: String
    }
    
    let count: Int
    let resetDate: Date

    init(json: Any, urlResponse: HTTPURLResponse) throws {
        guard
            let root = json as? [String: Any],
            let rate = root["rate"] as? [String: Any] else {
            throw DecodeError(json: json, description: "rate is not a dictionary")
        }
        
        guard let count = rate["limit"] as? Int else {
            throw DecodeError(json: json, description: "value for rate.limit is missing")
        }

        guard let resetDateString = rate["reset"] as? TimeInterval else {
            throw DecodeError(json: json, description: "value for rate.reset is missing")
        }

        self.count = count
        self.resetDate = Date(timeIntervalSince1970: resetDateString)
    }
}

//: Step 3: Define request type conforms to request protocol for the API.
// https://developer.github.com/v3/rate_limit/
struct GetRateLimitRequest: GitHubRequest {
    typealias Response = RateLimitResponse

    var method: HTTPMethod {
        return .get
    }

    var path: String {
        return "/rate_limit"
    }
}

//: Step 4: Send request.
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
