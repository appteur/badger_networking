//
//  JSONConvertable.swift
//  Networking
//
//  Created by Seth on 3/9/17.
//  Copyright © 2017 Arnott Industries, Inc. All rights reserved.
//

import Foundation

public protocol DictionaryConvertable {
    func toDictionary() -> [String : Any]?
}
