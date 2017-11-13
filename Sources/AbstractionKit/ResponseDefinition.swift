//
//  ResponseDefinition.swift
//  AbstractionKit
//
//  Created by Yuya Hirayama on 2017/09/24.
//  Copyright © 2017年 Yuya Hirayama. All rights reserved.
//

import Foundation

public protocol ResponseDefinition {
    associatedtype Result
    associatedtype JSON

    var result: Result { get }

    init(json: JSON) throws
}

public protocol DataResponseDefinition: ResponseDefinition {
    static var jsonKey: String { get }
}

public struct SingleResponse<T: SingleResponseElement>: DataResponseDefinition {
    public typealias Result = T
    public typealias JSON = [String: Any]

    public let result: Result

    public static var jsonKey: String {
        return T.singleKey
    }

    public init(json: JSON) throws {
        result = try T.decode(from: json)
    }
}

public struct ArrayResponse<T: ArrayResponseElement>: DataResponseDefinition {
    public typealias Result = [T]
    public typealias JSON = [[String: Any]]

    public let result: Result

    public static var jsonKey: String {
        return T.pluralKey
    }

    public init(json: JSON) throws {
        result = try T.decode(from: json)
    }
}

public struct EmptyResponse: ResponseDefinition {
    public typealias Result = Void
    public typealias JSON = Any?

    public let result: Result

    public init(json: JSON) throws {
        result = ()
    }
}

public struct CombinedResponse<T1: DataResponseDefinition, T2: DataResponseDefinition>: ResponseDefinition {
    public typealias Result = (T1.Result, T2.Result)
    public typealias JSON = [String: Any]

    public let result: Result

    public init(json: [String : Any]) throws {
        guard let t1JSON = json[T1.jsonKey] as? T1.JSON else {
            throw CombinedResponseError.keyNotFound(key: T1.jsonKey)
        }
        let t1 = try T1.init(json: t1JSON)

        guard let t2JSON = json[T2.jsonKey] as? T2.JSON else {
            throw CombinedResponseError.keyNotFound(key: T2.jsonKey)
        }
        let t2 = try T2.init(json: t2JSON)

        result = (t1.result, t2.result)
    }
}
