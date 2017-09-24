//
//  Models.swift
//  AbstractionKit
//
//  Created by Yuya Hirayama on 2017/09/24.
//  Copyright © 2017年 Yuya Hirayama. All rights reserved.
//

import Foundation
import AbstractionKit

struct User {
    var id: Int
    var name: String
}

extension User: SingleResponseElement {
    static var singleKey = "user"

    static func decode(from obj: Any) throws -> User {
        guard let json = obj as? [String: Any] else {
            throw DecodeError.castToJSONStructureFailed
        }

        return try User.init(
            id: json.getValue(forKey: "id"),
            name: json.getValue(forKey: "name")
        )
    }
}

extension User: ArrayResponseElement {
    static var pluralKey = "users"

    static func decode(from obj: Any) throws -> [User] {
        guard let json = obj as? [[String: Any]] else {
            throw DecodeError.castToJSONStructureFailed
        }

        return try json.map { try User.decode(from: $0) }
    }
}

enum DecodeError: Error {
    case castToJSONStructureFailed
}
