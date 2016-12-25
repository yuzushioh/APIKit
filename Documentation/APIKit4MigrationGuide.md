# APIKit 4 Migration Guide

## Overview

- [Response protocol](#response-protocol)
- [Refined HTTP body protocol](#refined-http-body-protocol)

## Response protocol

APIKit 4 introduces response protocol to separate resposibility of expressing requests and parsing responses. APIKit 4 provides root response protocol named `Response` and several sub-protocols for specific MIME types.

- [**Added**] `Response`

```swift
public protocol Response {
    init(data: Data, urlResponse: HTTPURLResponse) throws
}
```

### Sub-protocols for MIME types

- [**Added**] `JSONResponse` (`application/json`)
- [**Added**] `ProtobufResponse` (`application/protobuf`)
- [**Added**] `FormURLEncodedResponse` (`application/x-www-form-urlencoded`)

`DataParser` protocol and its sub-protocols are removed.

- [**Removed**] `DataParser`
- [**Removed**] `JSONDataParser`
- [**Removed**] `ProtobufDataParser`
- [**Removed**] `FormURLEncodedDataParser`
- [**Removed**] `StringDataParser`

### Data type conversion flow

Intermediate response type `Any` is removed.

- APIKit 3: `Data` → `Any` → `Response`
- APIKit 4: `Data` → `Response`

### Handling HTTP response

Since `Response` protocol takes all the responsibility for parsing response, response types should check HTTP status code and determine how to handle the response.

Here's example of handling HTTP response in custom response protocol for some web service. If the status code is in `200..<300`, response type will be instantiated from JSON. Otherwise, an error instantiated from JSON will be thrown.

```swift
protocol YourServiceResponse: JSONResponse {
    init(json: Any, urlResponse: HTTPURLResponse) throws {
        switch urlResponse.statusCode {
        case 200..<300:
            self = /* Instantiate from JSON */
        default:
            throw /* Instantiate Error from JSON */
        }
    }
}
```

Since `Response` protocol is resposible for parsing HTTP response, response related APIs in `Request` protocol are removed.

- [**Removed**] `Request.intercept(object:urlResponse:)`
- [**Removed**] `Request.response(from:urlResponse:)`

`Session.send(_:handler:)` no longer validate HTTP status and never returns `ResponseError.unacceptableStatusCode`, because these tasks overlap those of `Response` protocol.

- [**Removed**] `ResponseError.unacceptableStatusCode`
- [**Removed**] `ResponseError.unexpectedObject`
- [**Changed**] `Session.send(_:handler:)`
