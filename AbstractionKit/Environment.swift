//
//  Environment.swift
//  AbstractionKit
//
//  Created by Yuya Hirayama on 2017/09/24.
//  Copyright © 2017年 Yuya Hirayama. All rights reserved.
//

import Foundation

public protocol EnvironmentDefinition {
    var baseURLStr: String { get }

    func url(forPath: String) -> URL
}
