//
//  StatusHandler.swift
//  Networking
//
//  Created by Seth on 3/2/17.
//  Copyright © 2017 Arnott Industries, Inc. All rights reserved.
//

import Foundation


/// Provides an implementation of the ResponseStatusHandler protocol. This should be used in cases where handling of a URL request response based on http status code needs to be defined at runtime. In most cases an implementation of the sister protocol 'HTTPStatusHandler' should be sufficient, as it provides compile time handling of URL request responses based on http status codes.
public class StatusHandler<U: JSONParsable>: ResponseStatusHandler {
    public typealias T = U
    
    /// This defines a range of http status codes that this implementation will handle. By default it provides handling for URLResponses that fall in the 'success' range between 200-299. This can be updated to handle a single status code, or the entire range as desired.
    public var status: [Range<Int>] = [200..<300]
    
    /// Provides custom handling for a network response based on the http status code ranges enumerated in the 'status' var above, defined at runtime.
    public var handleResponse: ((inout NetworkResponse<T>) -> Void)?
    
    public init(status: [Range<Int>], handler: @escaping (inout NetworkResponse<T>) -> Void) {
        self.status = status
        self.handleResponse = handler
    }
    
}
