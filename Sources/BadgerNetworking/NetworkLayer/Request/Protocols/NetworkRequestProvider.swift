//
//  NetworkRequestProvider.swift
//  Networking
//
//  Created by Seth on 3/1/17.
//  Copyright © 2017 Arnott Industries, Inc. All rights reserved.
//

import Foundation
import Cocoa

/// Defines an interface for classes to implement to provide network accessibility.
public protocol NetworkRequestProvider {
    
    // A configuration object specifying the host and other parameters necessary for making network requests.
    var configuration: RemoteConfig { get set }
    
    /// The api layer sits 'on top of' the network layer, this provides a reference to the network layer actually handling the URLRequest objects.
    var networkLayer: NetworkRequestHandler! { get }
}

extension NetworkRequestProvider {

    //MARK: Request Handling (common caller for setting up the request from the route and passing to processRequest)
    public func handle<T: JSONParsable, R: NetworkRequestRouter>(route: R , responseType: T.Type, parameters: [String : Any]? = nil, headers: [String : String]? = nil, completion: @escaping (T?, Error?) -> Void) {
        // create our request from the given route
        let request = route.urlRequest(forConfig: configuration, params: parameters, headers: headers)
        // process the request using the default implementation provided by NetworkRequestProvider protocol
        processRequest(request, responseType: responseType, completion: completion)
    }

    /// Provides default request processing logic for objects conforming to the NetworkRequestProvider protocol. Calls the network layer and passes off the request, then in the completion checks for the error and calls the original completion with the parsed object or error if applicable.
    ///
    /// - Parameters:
    ///   - request: The URLRequest object to process.
    ///   - type: The type of model object the original caller expects to receive back from this call to the remote api.
    ///   - completion: The handler the original caller expects to run when requests to the api either succeed or fail.
    func processRequest<T: JSONParsable>(_ request: URLRequest, responseType type: T.Type, completion: @escaping (T?, Error?) -> Void) {
        
        networkLayer.process(withType: T.self, request: request, completion: { (response) in
            
            // handle response here, should have error or valid response object here
            guard response.error == nil else {
                print("Response Error: \(String(describing: response.error))")
                completion(nil, response.error)
                return
            }
            
            print("\(#function): responseObject: \(String(describing: response.object))")
            guard let object = response.object as? T else {
                print("No questions...")
                completion(nil, ApiError.responseParseError)
                return
            }
            
            completion(object, nil)
        })
    }
    
    /// Provides default implementation of image fetching logic for objects conforming to the NetworkRequestProvider protocol.
    ///
    /// - Parameters:
    ///   - path: The path to the image resource
    ///   - completion: On success/fail either a valid image will be returned or an error thrown.
    public func fetchImage(path: String, completion: @escaping (NSImage?, Error?) -> Void) {
        networkLayer.fetchImage(path: path, completion: { (data) in
            guard let data = data, let image = NSImage.init(data: data) else {
                print("AppApi fetchImage - nil data received or unable to create image for path: [\(path)")
                completion(nil, NetworkError.responseError)
                return
            }
            completion(image, nil)
        })
    }

    // currently unused, may be used in the future.
    public func processError(error: Error?) -> Bool {
        print("Response Error: \(String(describing: error))")
        return false
    }
}
