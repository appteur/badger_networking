//
//  NetworkSession.swift
//
//
//  Created by Seth on 7/25/16.
//  Copyright © 2016 Arnott Industries, Inc. All rights reserved.
//

import Foundation


/**
    Provides high level processing for network requests. 
 */
public class NetworkSession: NetworkRequestHandler {
    
    /// The remote configuration for this network session.
    var configuration: RemoteConfig
    
    /// This monitors network connectivity for this network session.
    internal var reachability: NetworkAccessibilityProvider?
    
    /// Interceptors in this array will be run on responses run through this session in order.
    public var responseInterceptors: [ResponseInterceptor] = [
        ResponseLogger(),       // logs responses to the console
        ResponseSerializer()    // parses response json into objects
    ]
    
    /// Sets up network session class and configures for the specified host based on the remote configuration received.
    /// Also sets up reachability for the host to manage network connectivity for the host specified in the configuration.
    ///
    /// - Parameter configuration: The remote configuration to use for setting up this network session
    public init(configuration: RemoteConfig) {
        self.configuration = configuration
        if configuration.enableReachability, let baseURL = configuration.baseURLComponents, let host = baseURL.host {
            print("NetworkSession: launching reachability with host: [\(host)]")
            reachability = NetworkReachability.init(host: host)
        }
    }
    
    
    /// Handles the main processing of the network request. The generic type specifies the type of object the caller expects to be
    /// returned as a parsed json object, as the 'object' property of the NetworkResponse object that is returned in the completion.
    ///
    /// - Parameters:
    ///   - withType: The type of model object expected to be parsed and returned in the response.
    ///   - request: The URL request to process.
    ///   - completion: Handler to run when url request completes or fails.
    public func process<T>(withType: T.Type, request: URLRequest, completion: @escaping (NetworkResponse<T>)->Void) {
        
        // check for network availability if enabled
        if configuration.enableReachability, let reachability = reachability, reachability.status != .unreachable {
            
            print("NetworkSession: Host reachability error, bailing")
            
            // TODO: setup automatic retry?
            
            // return a network response with error property set
            completion(NetworkResponse.init(error: NetworkError.networkUnreachable, request: request))
            return
        }
        
        // TODO: add to queue, queue completions when multiple requests are sent
        // to the same url
        
        // process request
        let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
            
            guard let strongself = self else {
                return
            }
            
            // create a network response object for this request
            var dataResponse = NetworkResponse<T>(response: response, error: error, data: data, request: request)
            
            // check for/handle request errors on global request scale (currently just logging)
            if dataResponse.error != nil {
                completion(dataResponse)
                return
            }

            // run response interceptors
            for interceptor in strongself.responseInterceptors {
                interceptor.handleResponse(response: &dataResponse)
            }
            
            // process based on http response status code (sets parsed object on NetworkResponse object)
//            strongself.processForStatus(response: &dataResponse)
            
            // complete & return our data response object
            completion(dataResponse)
        })
        
        // kick off request
        task.resume()
    }
    
    
    /// Provides uniform processing based on http response status codes. You define the ranges of codes to handle in the
    /// class instances, and the logic to process for each response status code.
    ///
    /// - Parameter response: This is the response object that will be passed back for the request. The response object is
    ///                         modified by the range status handlers as appropriate before being passed back in the 
    ///                         completion.
    func processForStatus<T>(response: inout NetworkResponse<T>) {
        
        guard response.statusCode > 0 else {
            return
        }
        
        let handlers: [HTTPStatusHandler] = [
            Range200Status(),
            Range300Status(),
            Range400Status(),
            Range500Status()
        ]
        
        for handler in handlers {
            if handler.canProcessStatus(response.statusCode) {
                handler.handleResponse(response: &response)
                return
            }
        }
    }
    
    
    //MARK: handle image download requests
    /// Simple image downloader for image requests. This version takes a path and calls the url version of this function.
    ///
    /// - Parameters:
    ///   - path: The path where the image is located.
    ///   - completion: On completion either a valid data object will be returned or nil if not found/loaded.
    public func fetchImage(path: String, completion: @escaping (Data?) -> Void) {
        guard let url = URL.init(string: path) else {
            print("Unable to create url for image download from path: [\(path)]")
            completion(nil)
            return
        }
        fetchImage(url: url, completion: completion)
    }
    
    
    /// Simple image downloader for image requests that takes a URL object instead of a path.
    ///
    /// - Parameters:
    ///   - url: The url where the image is located.
    ///   - completion: On completion returns either the valid image data or nil.
    public func fetchImage(url: URL, completion: @escaping (Data?) -> Void) {
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            guard let data = data, error == nil else {
                print("Image Download Anomaly for url: \(url)")
                completion(nil)
                return
            }
            print("Image Download Success: \(url)")
            completion(data)
        })
        task.resume()
    }
}
