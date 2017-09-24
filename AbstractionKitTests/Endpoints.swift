//
//  Endpoints.swift
//  AbstractionKit
//
//  Created by Yuya Hirayama on 2017/09/24.
//  Copyright © 2017年 Yuya Hirayama. All rights reserved.
//

import Foundation
import AbstractionKit

struct GetUser: EndpointDefinition {
    typealias Response = SingleResponse<User>

    static var path = "/user"

    static var environment: Environment = .init()

    var parameters: [String : Any] = [:]

    var method: HTTPMethod = .get
}

struct Environment: EnvironmentDefinition {
    var baseURLStr: String = "https://example.com"
}
