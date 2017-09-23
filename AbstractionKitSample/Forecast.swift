//
//  Forecast.swift
//  AbstractionKit
//
//  Created by Yuya Hirayama on 2017/09/24.
//  Copyright © 2017年 Yuya Hirayama. All rights reserved.
//

import Foundation
import AbstractionKit
import Himotoki

struct Forecast: ArrayResponseElement, Decodable {
    static var pluralKey = "forecasts"

    var date: Date
    var temperature: Double // Kelvin

    static func decode(_ e: Extractor) throws -> Forecast {

        return try Forecast.init(
            date: Date.init(timeIntervalSince1970: e <| "dt"),
            temperature: e <| ["main", "temp"]
        )
    }

    static func decode(from json: Any) throws -> [Forecast] {
        return try decodeArray(json)
    }
}

extension Forecast {
    var dateStr: String {
        let formatter = DateFormatter.init()
        formatter.dateStyle = .short
        formatter.timeStyle = .short

        return formatter.string(from: date)
    }

    var temperatureInFahrenheit: Double {
        return temperature * 9 / 5 - 459.67
    }
}
