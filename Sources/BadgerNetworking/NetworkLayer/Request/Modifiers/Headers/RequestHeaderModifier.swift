//
//  RequestHeaderModifier.swift
//  SampleApi
//
//  Created by Seth on 3/6/18.
//

import Foundation

/// Defines a request modifier that sets a dictionary of values on the request
/// as request headers.
public class RequestHeaderModifier: NetworkRequestModifier {
    
    var headers: [String: String]
    init(_ headers: [String: String]) {
        self.headers = headers
    }
    
    func configure(request: inout URLRequest, with config: RemoteConfig) {
        // iterate the headers dictionary and add each header to the request
        for (key,value) in headers {
            request.addValue(value, forHTTPHeaderField: key)
        }
    }
    
}
