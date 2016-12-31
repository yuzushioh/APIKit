import Foundation

/// `ProtobufResponse` protocol represents protobuf response.
public protocol ProtobufResponse {}

public extension ProtobufResponse {
    static var contentType: String? {
        return "application/protobuf"
    }
}
