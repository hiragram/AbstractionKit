//
//  Environment.swift
//  AbstractionKit
//
//  Created by Yuya Hirayama on 2017/09/24.
//  Copyright © 2017年 Yuya Hirayama. All rights reserved.
//

import Foundation

public protocol EnvironmentDefinition {
    var baseURLStr: String { get }
    var commonHeader: [String: String] { get }

    func url(forPath: String) -> URL
}

public extension EnvironmentDefinition {
    func url(forPath path: String) -> URL {
        return URL.init(string: baseURLStr + path)!
    }

    var commonHeader: [String: String] {
        return [:]
    }
}
