//
//  ResponseStatusHandler.swift
//  NetworkSuiteTest
//
//  Created by Seth on 2/6/17.
//  Copyright © 2017 Arnott Industries, Inc. All rights reserved.
//

import Foundation


/// This protocol describes a way to provide handling for http responses based on the http status code returned in the response. This is similar to the 'HTTPStatusHandler' protocol below, except that the 'handleResponse' functionality is a property instead of a function. This protocol is currently implemented in the 'StatusHandler' class found in the 'StatusHandlers' subdirectory of the NetworkLayer->Response directory. This implementation is not currently used, but is provided as an alternate way to provide handling for http status codes if desired. If you wish to define handling logic at runtime and switch between processing logic for a given http status code then an implementation of this protocol should be sufficient for that use case. If processing logic can be provided in advance then an implementation of the HTTPStatusHandler class is what you should use.
public protocol ResponseStatusHandler {
    
    associatedtype T: JSONParsable
    
    /// an array of ranges of status codes that this handler will process, this allows us to specify a range of values like 400...404, 409...499, and create a separate handler that will process a status code of 405
    var status: [Range<Int>] { get }
    
    /// this is the action that will occur if a response has an http response status code that falls within the range of status values specified in the 'status' property above. Returns T/F based on successful processing
    var handleResponse: ((inout NetworkResponse<T>) -> Void)? { get set }
    
    /// determines whether a given instance of a status handler will process the response for a given status code. 
    func canProcessStatus(_ status: Int) -> Bool
}

extension ResponseStatusHandler {
    
    /// Provides default implementation for determining whether an implementation of this protocol is able to process the response for a request based on the http status code.
    ///
    /// - Parameter status: The http status code for a given url response.
    /// - Returns: If the status code received falls within any of the ranges specified in the 'status' property of the implementing object then this function will return a 'true' response, else the response will be 'false'.
    public func canProcessStatus(_ status: Int) -> Bool {
        
        // iterate our ranges and see if the status code ranges contain this status code
        for range in self.status {
            if range.contains(status) {
                return true
            }
        }
        
        return false
    }
}


/// This protocol describes a way to provide handling for http responses based on the http status code returned in the response. This is similar to the 'ResponseStatusHandler' protocol above and is the version used in this networking library implementation for handling responses based on the response status code. For implementation examples see any of the 'Range<X>00Status' classes in the NetworkLayer->Response->StatusHandlers subdirectory. An implementation of this protocol is used when processing logic can be determined at compile time. If you need to vary processing logic at runtime then an implementation of ResponseStatusHandler should be used, and the logic setup/provided in the 'handleResponse var when an implementation of the protocol is instantiated/defined.
protocol HTTPStatusHandler {
    
    /// an array of ranges of status codes that this handler will process, this allows us to specify a range of values like 400...404, 409...499, and create a separate handler that will process a status code of 405
    var status: [Range<Int>] { get }
    
    /// this is the action that will occur if a response has an http response status code that falls within the range of status values specified in the 'status' property above. Returns T/F based on successful processing
    //    func handleResponse(_ response: inout NetworkResponse<T>)
    func handleResponse<T: JSONParsable>(response: inout NetworkResponse<T>)
    
    /// determines whether a given instance of a status handler will process the response for a given status code.
    func canProcessStatus(_ status: Int) -> Bool
}

extension HTTPStatusHandler {
    
    /// Provides default implementation for determining whether an implementation of this protocol is able to process the response for a request based on the http status code.
    ///
    /// - Parameter status: The http status code for a given url response.
    /// - Returns: If the status code received falls within any of the ranges specified in the 'status' property of the implementing object then this function will return a 'true' response, else the response will be 'false'.
    public func canProcessStatus(_ status: Int) -> Bool {
        
        // iterate our ranges and see if the status code ranges contain this status code
        for range in self.status {
            if range.contains(status) {
                return true
            }
        }
        
        return false
    }
}
