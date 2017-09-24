//
//  Abstraction.swift
//  AbstractionKit
//
//  Created by Yuya Hirayama on 2017/09/24.
//  Copyright © 2017年 Yuya Hirayama. All rights reserved.
//

import Foundation
import AbstractionKit
import APIKit
import RxSwift

/// Abstraction layer for forecast API
struct Abstraction {

    // - MARK: Internal methods

    /// Creates observable that emits objects API returned.
    ///
    /// - Parameter endpoint: Endpoint to perform request.
    /// - Returns: Single observable that emits objects API returned.
    fileprivate static func request<Endpoint: EndpointDefinition>(_ endpoint: Endpoint) -> Single<Endpoint.Response.Result> {
        return Single.create(subscribe: { (observer) -> Disposable in
            let request = APIKitBridgeRequest.init(endpoint: endpoint)
            let task = Session.send(request, callbackQueue: nil, handler: { (result) in
                switch result {
                case .success(let response):
                    observer(.success(response))
                case .failure(let error):
                    observer(.error(error))
                }
            })

            return Disposables.create {
                task?.cancel()
            }
        })
    }
}

// - MARK: Public methods for higher layers.

extension Abstraction {
    /// Get forecast information for city.
    ///
    /// - Parameters:
    ///   - cityName: The name of city
    ///   - countryCode: Country code
    /// - Returns: Single observable that emits Forecast object list.
    static func forecast(cityName: String, countryCode: String) -> Single<[Forecast]> {
        let endpoint = Endpoint.GetForecast.init(cityName: cityName, countryCode: countryCode)
        return request(endpoint)
    }
}

// - MARK: Server environment definition.

struct Environment: EnvironmentDefinition {
    var baseURLStr: String = "http://samples.openweathermap.org/data/2.5"
}

