//
//  500RangeResponse.swift
//  Networking
//
//  Created by Seth on 4/6/17.
//  Copyright © 2017 Seth. All rights reserved.
//

import Foundation


/// Handler for HTTP status codes in range: 5xx (server error)
public class Range500Status: HTTPStatusHandler {
    
    /// 'Status' is an array of ranges handled by this class. This can be set for a single status code or for an entire range as desired.
    public var status: [Range<Int>] = [500..<600]
    
    
    /// Logic to run for responses that come back with a server error response status code.
    ///
    /// - Parameter response: The network response to be updated with either a parsed json object or error.
    public func handleResponse<T>(response: inout NetworkResponse<T>) {
        // handle server error here
        // e.g. remedy error and retry
        print(" handle 5xx response here")
        
        // if we have response data, try to parse it out as a json object
        if let data = response.data, let json = try? JSONSerialization.jsonObject(with: data, options: []) {
            
            // it's json, is it a dictionary object?
            if let dictionary = json as? [String: Any] {
                
                // this will be our error description generated from the json response
                var errorDescription = ""
                
                for (key,value) in dictionary {
                    // if the top level value is a string, add a - to our description if there's already a value in it now
                    if let value = value as? String {
                        // add - if needed
                        if errorDescription.isEmpty == false {
                            errorDescription = errorDescription+" - "
                        }
                        // append this entry to our description
                        errorDescription = errorDescription+"\(key):\(value)"
                        
                      // this might be an array of strings, so try to parse that contigency and append to our error description.
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
                // create and set an ApiError on the response with the parsed description
                response.error = ApiError.apiError(message: errorDescription, errorName: "Api Error", code: response.statusCode)
            } else {
                // we were not able to parse the error, so set/return a generic unknown error.
                response.error = ApiError.unknownError
            }
        }
    }
}
