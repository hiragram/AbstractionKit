//
//  AbstractionKitTests.swift
//  AbstractionKitTests
//
//  Created by Yuya Hirayama on 2017/09/24.
//  Copyright © 2017年 Yuya Hirayama. All rights reserved.
//

import XCTest
@testable import AbstractionKit

class AbstractionKitTests: XCTestCase {
    func test_SingleResponse_success() {
        let dict: [String: Any] = [
            "id": 100,
            "name": "George",
        ]

        do {
            _ = try GetUser.Response.init(json: dict).result
        } catch let error {
            XCTFail("Unexpected error was thrown. \(error)")
        }
    }
} 
