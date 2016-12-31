import Foundation
import XCTest
import APIKit

class FormURLEncodedResponseTests: XCTestCase {
    struct Response: FormURLEncodedResponse {
        struct DecodeError: Error {}
        
        let value: String
        
        init(form: [String: String], urlResponse: HTTPURLResponse) throws {
            guard let value = form["key"] else {
                throw DecodeError()
            }
            
            self.value = value
        }
    }
    
    func testContentType() {
        XCTAssertEqual(Response.contentType, "application/x-www-form-urlencoded")
    }
    
    func testSuccess() {
        let string = "key=1&foo=2"
        let data = string.data(using: .utf8, allowLossyConversion: false)!

        do {
            let response = try Response(data: data, urlResponse: .dummy)
            XCTAssertEqual(response.value, "1")
        } catch {
            XCTFail()
        }
    }

    func testInvalidString() {
        var bytes = [UInt8]([0xed, 0xa0, 0x80]) // U+D800 (high surrogate)
        let data = Data(bytes: &bytes, count: bytes.count)

        do {
            _ = try Response(data: data, urlResponse: .dummy)
            XCTFail()
        } catch {
            guard case URLEncodedSerialization.Error.cannotGetStringFromData(let invalidData, let encoding) = error else {
                XCTFail()
                return
            }
            
            XCTAssertEqual(invalidData, data)
            XCTAssertEqual(encoding, Response.encoding)
        }
    }
}
