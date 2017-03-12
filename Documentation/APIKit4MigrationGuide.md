# APIKit 4 Migration Guide


## Added types

### Response

```swift
public protocol Response {
    associatedtype Parser: DataParser

    static var parser: Parser { get }

    init(data: Parser.Parsed, urlResponse: HTTPURLResponse) throws

    static func intercept(data: Data, urlResponse: HTTPURLResponse) throws -> (Data, HTTPURLResponse)
    static func intercept(parsed: Parser.Parsed, urlResponse: HTTPURLResponse) throws -> (Parser.Parsed, HTTPURLResponse)
    static func intercept(instance: Self, urlResponse: HTTPURLResponse) throws -> (Self, HTTPURLResponse)
}
```

## Modified types

### Request

Methods and associated types which is related to response are moved to `Response` protocol.

- [**Removed**] `Parser`
- [**Removed**] `intercept(object:urlResponse)`
