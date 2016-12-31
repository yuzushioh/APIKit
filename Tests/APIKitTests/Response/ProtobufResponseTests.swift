import Foundation
import XCTest
import APIKit

class ProtobufResponseTests: XCTestCase {
    struct Response: ProtobufResponse {
        struct DecodeError: Error {}
        
        let value: Any
    }
    
    func testContentType() {
        XCTAssertEqual(Response.contentType, "application/protobuf")
    }
}
