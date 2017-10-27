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
    struct GetForecast: EndpointDefinition {
        typealias Response = ListKeyResponse<ArrayResponse<Forecast>>
        static var path: String = "/forecast"
        static var environment: Environment = .init()
        let parameters: [String: Any]
        var method: HTTPMethod = .get

        var header: [String : String] {
            return ["Endpoint-Specific-Header": "Hello"]
        }

        init(cityName: String, countryCode: String) {
            parameters = [
                "q": "\(cityName),\(countryCode)",
                "appid": "_"
            ]
        }
    }
}

struct ListKeyResponse<T: DataResponseDefinition>: DataResponseDefinition {
    typealias Result = T.Result
    typealias JSON = [String: Any]

    var result: Result

    static var jsonKey: String {
        return "list"
    }

    init(json: JSON) throws {
        guard let tJSON = json[ListKeyResponse<T>.jsonKey] as? T.JSON else {
            throw CombinedResponseError.keyNotFound(key: ListKeyResponse<T>.jsonKey)
        }
        result = try T.init(json: tJSON).result
    }
}
