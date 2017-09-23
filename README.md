# AbstractionKit

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

## How to define response

See: [How to define response](Documentation/How_to_define_response.md)

## How to bridge between AbstractionKit and networking frameworks

_work in progress_

## How to bridge between AbstractionKit and mapping frameworks

_work in progress_

## How to create cool abstraction layer using AbstractionKit

_work in progress_