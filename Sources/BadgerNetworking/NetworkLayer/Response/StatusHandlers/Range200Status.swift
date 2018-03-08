//
//  200RangeResponse.swift
//  Networking
//
//  Created by Seth on 4/6/17.
//  Copyright © 2017 Seth. All rights reserved.
//

import Foundation

/*
 200    OK
 201    Created
 202    Accepted
 
 */

/// This class provides logic to run for URL responses that come back in the 'success' range of 200-299.
class Range200Status: HTTPStatusHandler {
    
    /// 'Status' is an array of ranges handled by this class. This can be set for a single status code or for an entire range as desired.
    var status: [Range<Int>] = [200..<300]
    
    /// Provides logic to run when a response is returned from the api with an http status code in the 'success' range.
    ///
    /// - Parameter response: This is the NetworkResponse object created in the NetworkSession class when URL requests are processed.
    /// This uses 'inout' and modifies the response object instead of creating a copy and returning it.
    func handleResponse<T>(response: inout NetworkResponse<T>) {
        
        /// If the response actually has data, then try to parse it as JSON into json object/etc.
        if let data = response.data, let json = try? JSONSerialization.jsonObject(with: data, options: []) {
            
            // check if the parsed json is a dictionary
            if let dictionary = json as? [String: Any] {
                
                print(":: PARSED JSON: \(dictionary)")
                response.object = T.parseJSON(json: dictionary)
            } else if let array = json as? [[String : Any]] {
                
                // if this response gave an array back, then put it in a dictionary with a 'parsed' key since our JSONParsable protocol expects a dictionary to parse.
                let dictionary: [String : Any] = [
                    "parsed" : array
                ]
                print(":: PARSED JSON: \(array)")
                response.object = T.parseJSON(json: dictionary)
            }
        }
    }
}
