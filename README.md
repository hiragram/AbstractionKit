# AbstractionKit

[![Build Status](https://travis-ci.org/hiragram/AbstractionKit.svg?branch=master)](https://travis-ci.org/hiragram/AbstractionKit)

AbstractionKit provides protocols and structs that make easier to abstract json API.

This does not depend on any other networking and mapping frameworks. So you can bridge between AbstractionKit and any frameworks you usually use.

## Overview

You can define your API endpoint as follows,

```swift
struct GetUser: EndpointDefinition {
    /// Means this endpoint returns single User object.
    typealias Response = SingleResponse<User>

    /// Path for resource.
    static var path: String = "/user"

    /// You can switch server for each endpoint.
    /// (You can use .staging or .mock if you defined.)
    static var environment: Environment = .production

    /// Parameters to contain in request.
    let parameters: [String: Any]

    /// HTTP method
    var method: HTTPMethod = .get

    init(userID: Int) {
        parameters = [
            "id": userID
        ]
    }
}
```

and you can simply extract objects from JSON as follows,

```swift
// `json` is a dictionary that API returned
let user = try GetUser.Response.init(json: json).result
```

## Sample app

A sample that uses [APIKit](https://github.com/ishkawa/APIKit), [Himotoki](https://github.com/ikesyo/Himotoki), and [RxSwift](https://github.com/ReactiveX/RxSwift) is available. Clone and run `$ carthage update` then run `AbstractionKitSample`.

## Installation

### Requirements

- Swift 3.1
- Xcode 8.3

__🔰 Swift 4 and Xcode 9 support is not available yet. 🔰__

### Carthage

- Add `github "hiragram/AbstractionKit" ~> 0.1` to your `Cartfile`.
- Run `$ carthage update`.
- Add built framework in `Carthage/Build/iOS/` to your project.
- Append `AbstractionKit.framework` to arguments of `$ carthage copy-frameworks`.

## How to define response

See: [How to define response](Documentation/How_to_define_response.md)

## How to bridge between AbstractionKit and networking frameworks

Create a wrapper for the network framework. The wrapper transforms AbstractionKit's endpoint instance to network framework's request object and generate object from response JSON.

For example, wrapper for APIKit is as follows,

```swift
struct APIKitBridgeRequest<Endpoint: EndpointDefinition>: APIKit.Request {
    typealias Response = Endpoint.Response.Result
    var baseURL: URL = Endpoint.environment.url(forPath: "")

    var path = Endpoint.path

    var parameters: Any? {
        return endpoint.parameters
    }

    var method: APIKit.HTTPMethod {
        return endpoint.method.apiKitMethod
    }

    private let endpoint: Endpoint

    init(endpoint: Endpoint) {
        self.endpoint = endpoint
    }

    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Endpoint.Response.Result {
        guard let jsonObj = object as? Endpoint.Response.JSON else {
            fatalError()
        }
        return try Endpoint.Response.init(json: jsonObj).result
    }
}
```

This wrapper has AbstractionKit's endpoint definition as a generic type parameter, and conforms to `APIKit.Request` protocol.

Then you create an instance of `APIKitBridgeRequest` and execute request.

```swift
// `GetUser.Response` is `SingleResponse<User>`
let endpoint = GetUser.init(userID: 100)
let request = APIKitBridgeRequest.init(endpoint: endpoint)
Session.send(request, callbackQueue: nil, handler: { (result) in
    switch result {
    case .success(let user):
        print(user)
    case .failure(let error):
        print(error)
    }
})
```

## How to bridge between AbstractionKit and mapping frameworks

`SingleResponseElement` and `ArrayResponseElement` are available to define model object types. Each protocol constraints to implement `decode` method. You can use any mapping framework in the method as follows,

```swift
struct User: SingleResponseElement, Himotoki.Decodable {
    static var singleKey = "user"

    var id: Int
    var name: String

    /// Implementation for Himotoki.Decodable
    static func decode(_ e: Extractor) throws -> User {
        return try User.init(
            id: e <| "id",
            name: e <| "name"
        )
    }

    /// Implementation for AbstractionKit.SingleResponseElement
    static func decode(from json: Any) throws -> User {
        // Using Himotoki internally.
        return try decodeValue(json)
    }
}
```

AbstractionKit does not depend on any mapping framework, so you can also map JSON to object manually. (Of course I will never recommend it.)

```swift
struct User: SingleResponseElement {
    static var singleKey = "user"

    var id: Int
    var name: String

    /// Implementation for AbstractionKit.SingleResponseElement
    static func decode(from obj: Any) throws -> User {
        let json = obj as! [String: Any]

        return User.init(
            id: json["id"] as! Int,
            name: json["name"] as! String
        )
    }
}
```

## How to create cool abstraction layer using AbstractionKit

_work in progress_