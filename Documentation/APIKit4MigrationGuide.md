# APIKit 4 Migration Guide


## Added types

### Response

```swift
public protocol Response {
    associatedtype DataParser: APIKit.DataParser

    static var dataParser: DataParser { get }

    init(parsedData: DataParser.Parsed, urlResponse: HTTPURLResponse) throws

    static func intercept(data: Data, urlResponse: HTTPURLResponse) throws -> (Data, HTTPURLResponse)
    static func intercept(parsedData: DataParser.Parsed, urlResponse: HTTPURLResponse) throws -> (DataParser.Parsed, HTTPURLResponse)
    static func intercept(instance: Self, urlResponse: HTTPURLResponse) throws -> (Self, HTTPURLResponse)
}
```

## Modified types

### Request

Methods and associated types which is related to response are moved to `Response` protocol.

- [**Removed**] `Parser`
- [**Removed**] `intercept(object:urlResponse)`
