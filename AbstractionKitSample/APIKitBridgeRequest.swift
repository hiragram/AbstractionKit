//
//  APIKitBridgeRequest.swift
//  AbstractionKit
//
//  Created by Yuya Hirayama on 2017/09/24.
//  Copyright © 2017年 Yuya Hirayama. All rights reserved.
//

import Foundation
import APIKit
import AbstractionKit

/// Bridges network process between AbstractionKit and APIKit.
struct APIKitBridgeRequest<Endpoint: EndpointDefinition>: APIKit.Request {
    typealias Response = Endpoint.Response.Result
    var baseURL: URL = Endpoint.environment.url(forPath: "")

    var path: String {
        return endpoint.path
    }

    var parameters: Any? {
        return endpoint.parameters
    }

    var method: APIKit.HTTPMethod {
        return endpoint.method.apiKitMethod
    }

    var headerFields: [String: String] {
        return Endpoint.environment.commonHeader.merging(endpoint.header, uniquingKeysWith: { $1 })
    }

    private let endpoint: Endpoint

    init(endpoint: Endpoint) {
        self.endpoint = endpoint
    }

    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Endpoint.Response.Result {
        guard let jsonObj = object as? Endpoint.Response.JSON else {
            fatalError()
        }
        return try Endpoint.Response.init(json: jsonObj).result
    }
}

extension AbstractionKit.HTTPMethod {
    var apiKitMethod: APIKit.HTTPMethod {
        switch self {
        case .get:
            return .get
        case .post:
            return .post
        case .delete:
            return .delete
        case .patch:
            return .patch
        }
    }
}
