//
//  NetworkResponse.swift
//  NetworkSuiteTest
//
//  Created by Seth on 2/3/17.
//  Copyright © 2017 Arnott Industries, Inc. All rights reserved.
//

import Foundation


/// This is the model object that is setup and returned when network URL requests have been processed. It is returned as the response object for all requests processed by the network session for this library. The generic T:JSONParsable specifies the type of parsed model object that the requestor expects to receive back from the request to the configured api. For instance, a request to the api might expect a json object to be returned that defines a user object, in this case the type specified would be something along the lines of 'User.self'. In this case the NetworkSession would attempt to create the requested User object (that conforms to the JSONParsable protocol) and populate it's properties from the json object returned from the api.
public class NetworkResponse<T: JSONParsable> {
    
    /// Defines an object expected to be parsed and set in the response from a network/api request.
    public var object: T.ParsedObject?
    
    /// Links to the actual response received from a URLRequest that this response object is populated from.
    public var response: HTTPURLResponse?
    
    /// The http status code for the response above that was received. Placed here for easy access later if needed.
    public var statusCode: Int = 0
    
    /// If any errors are encountered in the request pipeline for a URL request this object will be set, else it will be nil.
    public var error: Error?
    
    /// Contains the actual data received (if any) for the request this response is being generated for.
    public var data: Data?
    
    public init(object: T.ParsedObject? = nil, response: HTTPURLResponse? = nil, error: Error? = nil, data: Data? = nil) {
        self.object = object
        self.response = response
        self.error = error
        self.data = data
    }
}

