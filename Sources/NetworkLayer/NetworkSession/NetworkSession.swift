//
//  NetworkSession.swift
//
//
//  Created by Seth on 7/25/16.
//  Copyright © 2016 Arnott Industries, Inc. All rights reserved.
//

import Foundation


/*
    Provides high level processing for requests. The type that applies to all requests.
 */
class NetworkSession: NetworkRequestHandler {
    
    /// The remote configuration for this network session.
    var configuration: RemoteConfig?
    
    /// This monitors network connectivity for this network session.
    internal var reachability: NetworkAccessibilityProvider?
    
    /// Enable or disable successful logs for all requests.
    /// (no logs in release regardless of setting, and requests w/o response of 200 are automatically logged for debugging)
    let logRequests = true
    
    
    /// Sets up network session class and configures for the specified host based on the remote configuration received.
    /// Also sets up reachability for the host to manage network connectivity for the host specified in the configuration.
    ///
    /// - Parameter configuration: The remote configuration to use for setting up this network session
    init(configuration: RemoteConfig) {
        self.configuration = configuration
        if let baseURL = configuration.baseURLComponents, let host = baseURL.host {
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
    func process<T>(withType: T.Type, request: URLRequest, completion: @escaping (NetworkResponse<T>)->Void) {
        
        // check for network availability
        guard let reachability = reachability, reachability.status != .unreachable else {
            print("NetworkSession: Host reachability error, bailing")
            completion(NetworkResponse.init(error: NetworkError.networkUnreachable))
            return
        }
        
        // TODO: add to queue, queue completions when multiple requests are sent
        // to the same url
        
        // process request
        let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
            
            guard let weakself = self else {
                return
            }
            
            // create the response we'll return
            var dataResponse = NetworkResponse<T>(error: error, data: data)
            
            // check for/handle request errors on global request scale (currently just logging)
            guard error == nil else  {
                dataResponse.error = error
                weakself.handleError(error: error!)
                completion(dataResponse)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("NetworkSession: Unable to validate response")
                dataResponse.error = NetworkError.responseError
                completion(dataResponse)
                return
            }
            
            print("NetworkSession: [\(String(describing: request.url))] Response Code: \(httpResponse.statusCode)")
            // set response status code
            dataResponse.statusCode = httpResponse.statusCode
            
            // log requests if enabled
            weakself.logRawRequest(data: data! as Data, responseCode: httpResponse.statusCode)

            // update response object
            dataResponse.response = httpResponse
            
            // process based on http response status code (sets parsed object on NetworkResponse object)
            weakself.processForStatus(response: &dataResponse)
            
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
        
        guard let status = response.response?.statusCode else {
            return
        }
        
        let handlers: [HTTPStatusHandler] = [
            Range200Status(),
            Range300Status(),
            Range400Status(),
            Range500Status()
        ]
        
        for handler in handlers {
            if handler.canProcessStatus(status) {
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
    func fetchImage(path: String, completion: @escaping (Data?) -> Void) {
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
    func fetchImage(url: URL, completion: @escaping (Data?) -> Void) {
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

// MARK: Logging & Error Handling
extension NetworkSession {
    
    /// Provides global error handling for all responses from the server. 
    /// This handles network errors, not api errors.
    ///
    /// - Parameter error: The error thrown, to be processed.
    func handleError(error:Error) {
        print("NetworkSession: TODO: handle response error: \(error)")
    }
    
    /// Convenience function for logging of requests and keeping code cleaner.
    ///
    /// - Parameters:
    ///   - data: Response data to be logged to the console.
    ///   - responseCode: The response code for the response being logged. Used to automatically log all
    ///                     responses that are not successful.
    func logRawRequest(data:Data, responseCode:Int) {
//        #if DEBUG
            if logRequests == true || (responseCode != 200) {
                let returnStr = String.init(data: data, encoding: String.Encoding.utf8)
                print("LogRawRequest: \(String(describing: returnStr))")
            }
//        #endif
    }
}
