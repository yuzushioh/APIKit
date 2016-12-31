import Foundation
import XCTest
import APIKit

class JSONResponseTests: XCTestCase {
    struct Response: JSONResponse {
        struct DecodeError: Error {}
        
        let value: Any
        
        init(json: Any, urlResponse: HTTPURLResponse) throws {
            guard
                let dictionary = json as? [String: Any],
                let value = dictionary["key"] else {
                throw DecodeError()
            }
            
            self.value = value
        }
    }
    
    func testContentType() {
        XCTAssertEqual(Response.contentType, "application/json")
    }
    
    func testSuccess() {
        let string = "{\"key\": 1, \"foo\": 2}"
        let data = string.data(using: .utf8, allowLossyConversion: false)!

        do {
            let response = try Response(data: data, urlResponse: .dummy)
            XCTAssertEqual(response.value as? Int, 1)
        } catch {
            XCTFail()
        }
    }
}
