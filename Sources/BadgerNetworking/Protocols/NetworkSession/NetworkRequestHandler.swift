//
//  NetworkRequestHandler
//  
//
//  Created by Seth on 10/4/16.
//  Copyright © 2016 seth. All rights reserved.
//

import Foundation

// Defines interface for the network class to implement.
public protocol NetworkRequestHandler {
    
    /// An implementation of this protocol should include a way to process (or stub possibly) requests and return
    /// a response object with a parsed object in the completion.
    ///
    /// - Parameters:
    ///   - withType: The type of model object expected to be parsed from the response json and returned as part of the response object.
    ///   - request: An instance of a URL request to process.
    ///   - completion: Handler to run when the URL request is processed or on failure.
    func process<T: JSONParsable>(withType: T.Type, request:URLRequest, completion: @escaping (NetworkResponse<T>)->Void)
    
    
    /// Basic image fetching using a String path specifying the image location.
    ///
    /// - Parameters:
    ///   - path: The path where the desired image is located.
    ///   - completion: On request completion either the valid image data is returned or nil.
    func fetchImage(path: String, completion: @escaping (Data?) -> Void)
    
    
    /// Basic image fetchign using a URL object specifying the desired image's location.
    ///
    /// - Parameters:
    ///   - url: The url where the image is located.
    ///   - completion: On completion returns either the valid image data or nil.
    func fetchImage(url: URL, completion: @escaping (Data?) -> Void)
}
