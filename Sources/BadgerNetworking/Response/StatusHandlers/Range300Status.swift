//
//  RangeStatusHandlers.swift
//  Networking
//
//  Created by Seth on 3/2/17.
//  Copyright © 2017 Arnott Industries, Inc. All rights reserved.
//

import Foundation

/// This class provides logic to run for URL responses that come back in the 'redirect' range of 300-399.
public class Range300Status: HTTPStatusHandler {

    /// 'Status' is an array of ranges handled by this class. This can be set for a single status code or for an entire range as desired.
    public var status: [Range<Int>] = [300..<400]

    
    /// Provide logic to run for responses that come back as a redirect.
    ///
    /// - Parameter response: The network response that will be returned and should be modified as needed here.
    public func handleResponse<T>(response: inout NetworkResponse<T>) {
        print("Handle HTTP status codes in 300 range")
    }
}
