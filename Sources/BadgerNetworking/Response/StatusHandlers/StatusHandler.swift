//
//  StatusHandler.swift
//  Networking
//
//  Created by Seth on 3/2/17.
//  Copyright © 2017 Arnott Industries, Inc. All rights reserved.
//

import Foundation

/// This protocol describes a way to provide handling for http responses based on the http status code returned in the response. This is similar to the 'HTTPStatusHandler' protocol below, except that the 'handleResponse' functionality is a property instead of a function. This protocol is currently implemented in the 'StatusHandler' class found in the 'StatusHandlers' subdirectory of the NetworkLayer->Response directory. This implementation is not currently used, but is provided as an alternate way to provide handling for http status codes if desired. If you wish to define handling logic at runtime and switch between processing logic for a given http status code then an implementation of this protocol should be sufficient for that use case. If processing logic can be provided in advance then an implementation of the HTTPStatusHandler class is what you should use.
//protocol ResponseStatusHandler {
//    
//    associatedtype T: JSONParsable
//    
//    /// an array of ranges of status codes that this handler will process, this allows us to specify a range of values like 400...404, 409...499, and create a separate handler that will process a status code of 405
//    var status: [Range<Int>] { get }
//    
//    /// this is the action that will occur if a response has an http response status code that falls within the range of status values specified in the 'status' property above. Returns T/F based on successful processing
//    var handleResponse: ((inout NetworkResponse<T>) -> Void)? { get set }
//    
//    /// determines whether a given instance of a status handler will process the response for a given status code.
//    func canProcessStatus(_ status: Int) -> Bool
//}
//
//extension ResponseStatusHandler {
//    
//    /// Provides default implementation for determining whether an implementation of this protocol is able to process the response for a request based on the http status code.
//    ///
//    /// - Parameter status: The http status code for a given url response.
//    /// - Returns: If the status code received falls within any of the ranges specified in the 'status' property of the implementing object then this function will return a 'true' response, else the response will be 'false'.
//    func canProcessStatus(_ status: Int) -> Bool {
//        
//        // iterate our ranges and see if the status code ranges contain this status code
//        for range in self.status {
//            if range.contains(status) {
//                return true
//            }
//        }
//        
//        return false
//    }
//}



/// Provides an implementation of the ResponseStatusHandler protocol. This should be used in cases where handling of a URL request response based on http status code needs to be defined at runtime. In most cases an implementation of the sister protocol 'HTTPStatusHandler' should be sufficient, as it provides compile time handling of URL request responses based on http status codes.
//public class StatusHandler<U: JSONParsable>: ResponseStatusHandler {
//    public typealias T = U
//    
//    /// This defines a range of http status codes that this implementation will handle. By default it provides handling for URLResponses that fall in the 'success' range between 200-299. This can be updated to handle a single status code, or the entire range as desired.
//    public var status: [Range<Int>] = [200..<300]
//    
//    /// Provides custom handling for a network response based on the http status code ranges enumerated in the 'status' var above, defined at runtime.
//    public var handleResponse: ((inout NetworkResponse<T>) -> Void)?
//    
//    public init(status: [Range<Int>], handler: @escaping (inout NetworkResponse<T>) -> Void) {
//        self.status = status
//        self.handleResponse = handler
//    }
//    
//}

