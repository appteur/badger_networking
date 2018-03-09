//
//  ResponseLogger.swift
//  BadgerNetworking
//
//  Created by Seth on 3/8/18.
//

import Foundation

/// This class provides logic to run for URL responses that come back in the 'success' range of 200-299.
public class ResponseLogger: ResponseInterceptor {
    
    /// Provides logic to run when a response is returned from the api with an http status code in the 'success' range.
    ///
    /// - Parameter response: This is the NetworkResponse object created in the NetworkSession class when URL requests are processed.
    /// This uses 'inout' and modifies the response object instead of creating a copy and returning it.
    public func handleResponse<T>(response: inout NetworkResponse<T>) {
        
        print("NetworkSession: [\(String(describing: response.originalRequest?.url))] Response Code: \(response.statusCode)")
        
        guard let data = response.data else {
            return
        }
        
        /// If the response actually has data, then try to parse it as JSON into json object/etc.
        if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
            print("NetworkSession RESPONSE: \(json)")
        } else {
            let returnStr = String.init(data: data, encoding: String.Encoding.utf8)
            print("NetworkSession RAW RESPONSE: \(String(describing: returnStr))")
        }
    }
}
