//
//  400RangeResponse.swift
//  Networking
//
//  Created by Seth on 4/6/17.
//  Copyright © 2017 Seth. All rights reserved.
//

import Foundation

/*
 400    Bad Request
 401    Unauthorized
 402    Payment Required
 403    Forbidden
 404    Not Found
 405    Method Not Allowed
 413    Request Entity Too Large
 */

/// Handler for HTTP status codes in the range: 4xx (client error)
public class Range400Status: HTTPStatusHandler {
    
    /// 'Status' is an array of ranges handled by this class. This can be set for a single status code or for an entire range as desired.
    public var status: [Range<Int>] = [400..<500]
    
    
    /// Logic to run for responses that come back with a client error response status code.
    ///
    /// - Parameter response: The network response to be updated with either a parsed json object or error.
    public func handleResponse<T>(response: inout NetworkResponse<T>) {
        // handle client error here
        // e.g. remedy error and retry
        print(" handle 4xx response here")
        
        // if we have response data, try to parse out a json object from the response data.
        if let data = response.data, let json = try? JSONSerialization.jsonObject(with: data, options: []) {
            
            // if we got an error response dictionary back from the api then try to parse it here.
            if let dictionary = json as? [String: Any] {
                
                // this is the error description that will be set/returned.
                var errorDescription = ""
                
                // enumerate the key/values of the response and construct our error description string
                for (key,value) in dictionary {
                    
                    // if we have a valid value string then update our error description var to append this one
                    if let value = value as? String {
                        // add - if needed (if we already have a description and we're appending to a value already here)
                        if errorDescription.isEmpty == false {
                            errorDescription = errorDescription+" - "
                        }
                        // update our error description with this key/value
                        errorDescription = errorDescription+"\(key):\(value)"
                        
                      // this might be an array of strings so try to parse/append this to the error description
                    } else if let subArray = value as? [String] {
                        
                        for value in subArray {
                            if errorDescription.isEmpty == false {
                                errorDescription = errorDescription+", "
                            }
                            errorDescription = errorDescription+value
                        }
                        errorDescription = "\(key): \(errorDescription)"
                    }
                }
                // create an ApiError object and set the custom error with our generated error description.
                response.error = ApiError.apiError(message: errorDescription, errorName: "Api Error", code: response.statusCode)
            } else {
                // we have an error but were unable to parse any json, so return/set a generic unknown error
                response.error = ApiError.unknownError
            }
        }
    }
}
