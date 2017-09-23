# How to define response

Let's consider the case of fetching information about user.

```swift
struct GetUser: EndpointDefinition {
    typealias Response = ❓🤔

    static var environment: Environment = .init()
    static var path: String = "/user"

    var parameters: [String : Any] = [:]

    var method: HTTPMethod = .get
}
```

AbstractionKit provides some structs that models JSON object.

### SingleResponse

You can use `SingleResponse<User>` if API returns single `User` object.

```json
{
    "id": 100,
    "name": "George"
}
```

```swift
// `user` will be User(id: 100, name: "George")
let user = try GetUser.Response.init(json: json).result
```

### ArrayResponse

You can use `ArrayResponse<User>` if API returns some `User` objects.

```json
[
    {
        "id": 100,
        "name": "George"
    },
    {
        "id": 101,
        "name": "Mary"
    },
    {
        "id": 102,
        "name": "Tom"
    }
]
```

```swift
// `users` will be [User(id: 100, name: "George"), User(id: 101, name: "Mary"), User(id: 102, name: "Tom")]
let users = try GetUser.Response.init(json: json).result
```

### EmptyResponse

You can use `EmptyResponse` if you do not need to parse response JSON. (I assume to use this like when POST request does not return the new object.)

```json
{
    "success": true,
    "message": "Successfully updated."
}
```

```swift
// Returned value is `()`.
try GetUser.Response.init(json: json).result
```

### CombinedResponse

You can use `CombinedResponse` when returned API is more complex.

For example, when JSON contains array of `User` and single `School` object as follows, you can use `CombinedResponse<ArrayResponse<User>, SingleResponse<School>>`.

```json
{
    "users": [
        {
            "id": 100,
            "name": "George"
        },
        {
            "id": 101,
            "name": "Mary"
        },
        {
            "id": 102,
            "name": "Tom"
        }
    ],
    "school": {
        "id": 10000,
        "name": "Tokyo school",
        "number_of_students": 3
    }
}
```

```swift
// Type of `result` will be `([User], School)`.
let result = try GetUser.Response.init(json: json).result
let users = result.0 // `[User]`
let school = result.1 // `School`
```

In this case, `singleKey` in `SingleResponseElement` and `pluralKey` in `ArrayResponseElement` will be used as the JSON key.

### Defining custom structure

I know that you cannot always correspond with your API on structs above. In such a case, you can define custom structure of JSON using AbstractionKit's protocols.

For example, I assume that API returns JSON as follows,

```json
{
    "info": {
        "success": true,
        "message": "Server is fine!",
        "timestamp": 1506195673
    },
    "results": [
        {
            "id": 100,
            "name": "George"
        },
        {
            "id": 101,
            "name": "Mary"
        },
        {
            "id": 102,
            "name": "Tom"
        }     
    ]
}
```

This case means, 

- You do not have to parse `"info"` object
- You want to extract `User` objects but key is different from `User`'s `pluralKey`.

You can define JSON structure as follows,

```swift
struct ResultKeyResponse<T: DataResponseDefinition>: DataResponseDefinition {
    typealias Result = T.Result
    typealias JSON = [String: Any]

    var result: Result

    static var jsonKey: String {
        return "results"
    }

    init(json: JSON) throws {
        guard let tJSON = json[ListKeyResponse<T>.jsonKey] as? T.JSON else {
            throw CombinedResponseError.keyNotFound(key: ListKeyResponse<T>.jsonKey)
        }
        result = try T.init(json: tJSON).result
    }
}
```

Then you can extract `User` objects like this.

```swift
// `users` will be [User(id: 100, name: "George"), User(id: 101, name: "Mary"), User(id: 102, name: "Tom")]
let users = try GetUser.Response.init(json: json).result
```

`CombinedResponse` supports combination of two types, but if your API returns combination of three or more types, you can create `ThreeCombinedResponse` in the same way.