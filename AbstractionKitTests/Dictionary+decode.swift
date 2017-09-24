//
//  Dictionary+decode.swift
//  AbstractionKit
//
//  Created by Yuya Hirayama on 2017/09/24.
//  Copyright © 2017年 Yuya Hirayama. All rights reserved.
//

import Foundation

extension Dictionary where Key == String {
    func getValue<T>(forKey key: Key) throws -> T {
        guard let value = self[key] else {
            throw DictionaryExtractionError.keyNotFound(key)
        }
        guard let castedValue = value as? T else {
            throw DictionaryExtractionError.castFailed(key: key, expectedType: T.self, actualValue: value)
        }

        return castedValue
    }

    func getArray<T>(forKey key: Key) throws -> [T] {
        guard let value = self[key] else {
            throw DictionaryExtractionError.keyNotFound(key)
        }
        guard let array = value as? [T] else {
            throw DictionaryExtractionError.castFailed(key: key, expectedType: [T].self, actualValue: value)
        }

        return array
    }

    func getURL(forKey key: Key) throws -> URL? {
        guard let value = self[key] else {
            return nil
        }
        guard let urlStr = value as? String else {
            throw DictionaryExtractionError.castFailed(key: key, expectedType: String.self, actualValue: value)
        }
        return URL.init(string: urlStr)
    }

    func getURL(forKey key: Key) throws -> URL {
        guard let url = try getURL(forKey: key) as URL? else {
            throw DictionaryExtractionError.convertToURLFailed(key: key, actualValue: self[key] as Any)
        }
        return url
    }
}

enum DictionaryExtractionError: Error {
    case keyNotFound(String)
    case castFailed(key: String, expectedType: Any.Type, actualValue: Any)
    case convertToURLFailed(key: String, actualValue: Any)
}
