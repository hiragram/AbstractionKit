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

struct Abstraction {
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

extension Abstraction {
    static func forecast(cityName: String, countryCode: String) -> Single<[Forecast]> {
        let endpoint = Endpoint.GetForecast.init(cityName: cityName, countryCode: countryCode)
        return request(endpoint)
    }
}

struct Environment: EnvironmentDefinition {
    var baseURLStr: String = "http://samples.openweathermap.org/data/2.5"
}

