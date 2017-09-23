//
//  Endpoint.swift
//  AbstractionKit
//
//  Created by Yuya Hirayama on 2017/09/24.
//  Copyright © 2017年 Yuya Hirayama. All rights reserved.
//

import Foundation
import AbstractionKit

struct Endpoint {
    struct Forecast: EndpointDefinition {
        typealias Response = EmptyResponse
        static var path: String = "/forecast"
        static var environment: Environment = .init()
        let parameters: [String: Any]
        var method: HTTPMethod = .get

        init(cityName: String, countryCode: String) {
            parameters = [
                "q": "\(cityName),\(countryCode)"
            ]
        }
    }
}
