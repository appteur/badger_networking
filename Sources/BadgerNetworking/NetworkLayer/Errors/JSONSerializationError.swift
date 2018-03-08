//
//  JSONSerializationError.swift
//  Networking
//
//  Created by Seth on 6/2/17.
//  Copyright © 2017 Seth. All rights reserved.
//

import Foundation

enum SerializationError: Error {
    case missing(String)
    case invalid(String, Any)
}
