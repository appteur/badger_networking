//
//  JSONParsable.swift
//  Networking
//
//  Created by Seth on 3/9/17.
//  Copyright © 2017 Arnott Industries, Inc. All rights reserved.
//

import Foundation

public protocol JSONParsable {
    associatedtype ParsedObject
    static func parseJSON(json: [String: Any]) -> ParsedObject?
}

public protocol JSONInitable {
    init(json: [String: Any]) throws
}

public protocol ObjectSerializer {
    func value(in dict: [String: Any]) throws -> Any
}
