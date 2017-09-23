//
//  ResponseDefinition.swift
//  AbstractionKit
//
//  Created by Yuya Hirayama on 2017/09/24.
//  Copyright © 2017年 Yuya Hirayama. All rights reserved.
//

import Foundation

protocol ResponseDefinition {
    associatedtype Result
    associatedtype JSON

    var result: Result { get }

    init(json: JSON) throws
}

protocol DataResponseDefinition: ResponseDefinition {
    static var jsonKey: String { get }
}

struct SingleResponse<T: SingleResponseElement>: DataResponseDefinition {
    typealias Result = T
    typealias JSON = [String: Any]

    let result: Result

    static var jsonKey: String {
        return T.singleKey
    }

    init(json: JSON) throws {
        result = try T.decode(from: json)
    }
}

struct ArrayResponse<T: ArrayResponseElement>: DataResponseDefinition {
    typealias Result = [T]
    typealias JSON = [[String: Any]]

    let result: Result

    static var jsonKey: String {
        return T.pluralKey
    }

    init(json: JSON) throws {
        result = try T.decode(from: json)
    }
}

struct EmptyResponse: ResponseDefinition {
    typealias Result = Void
    typealias JSON = Any?

    let result: Result

    init(json: JSON) throws {
        result = ()
    }
}

struct CombinedResponse<T1: DataResponseDefinition, T2: DataResponseDefinition>: ResponseDefinition {
    typealias Result = (T1.Result, T2.Result)
    typealias JSON = [String: Any]

    let result: Result

    init(json: [String : Any]) throws {
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
