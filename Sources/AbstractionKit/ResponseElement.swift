//
//  ResponseElement.swift
//  AbstractionKit
//
//  Created by Yuya Hirayama on 2017/09/24.
//  Copyright © 2017年 Yuya Hirayama. All rights reserved.
//

import Foundation

public protocol ResponseElement {
}

public protocol SingleResponseElement: ResponseElement {
    static var singleKey: String { get }
    static func decode(from: Any) throws -> Self
}

public protocol ArrayResponseElement: ResponseElement {
    static var pluralKey: String { get }
    static func decode(from: Any) throws -> [Self]
}
