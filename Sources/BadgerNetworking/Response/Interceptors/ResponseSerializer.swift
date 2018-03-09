//
//  ResponseSerializer.swift
//  BadgerNetworking
//
//  Created by Seth on 3/8/18.
//

import Foundation

/// This class provides logic to run for URL responses that come back in the 'success' range of 200-299.
public class ResponseSerializer: ResponseInterceptor {
    
    /// Provides logic to run when a response is returned from the api with an http status code in the 'success' range.
    ///
    /// - Parameter response: This is the NetworkResponse object created in the NetworkSession class when URL requests are processed.
    /// This uses 'inout' and modifies the response object instead of creating a copy and returning it.
    public func handleResponse<T>(response: inout NetworkResponse<T>) {
        
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
