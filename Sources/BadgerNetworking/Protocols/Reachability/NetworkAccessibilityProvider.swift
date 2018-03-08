//
//  NetworkAccessibilityProvider.swift
//  NetworkSuiteTest
//
//  Created by Seth on 2/3/17.
//  Copyright © 2017 Arnott Industries, Inc. All rights reserved.
//

import Foundation

public enum NetworkAccessibilityStatus {
    case reachableViaCellular
    case reachableViaWifi
    case unreachable
}

public protocol NetworkAccessibilityProvider {
    
    var status: NetworkAccessibilityStatus { get set }
    
    func configure(for host: String)
}

