//
//  EndpointDefinition.swift
//  AbstractionKit
//
//  Created by Yuya Hirayama on 2017/09/24.
//  Copyright © 2017年 Yuya Hirayama. All rights reserved.
//

import Foundation

public protocol EndpointDefinition {
    associatedtype Response: ResponseDefinition
    associatedtype Environment: EnvironmentDefinition

    static var path: String { get }
    static var environment: Environment { get }

    var parameters: [String: Any] { get }
    var method: HTTPMethod { get }
}
