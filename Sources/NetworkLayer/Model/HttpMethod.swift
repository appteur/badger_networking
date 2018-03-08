//
//  HttpMethod.swift
//  Networking
//
//  Created by Seth on 4/7/17.
//  Copyright © 2017 Seth. All rights reserved.
//

import Foundation

/// Provides http methods as an enum for easier use throughout the networking library.
enum HttpMethod: String {
    case head = "HEAD"
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case options = "OPTIONS"
    case connect = "CONNECT"
    case trace = "TRACE"
    case patch = "PATCH"
}


