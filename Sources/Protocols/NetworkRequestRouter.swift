//
//  APIRouter.swift
//  Networking
//
//  Created by Seth Arnott on 2/03/17.
//  Copyright © 2017 Arnott Industries, Inc. All rights reserved.
//

import Foundation
import Cocoa


/// Specifies functionality that should be implemented in objects providing routing information for api requests.
protocol NetworkRequestRouter {
    /// Defines modifiers that should be used for requests sent to a remote api. They can be global and cover all requests or be configured separately for each request as needed.
    var requestModifiers: [NetworkRequestModifier] { get }
    
	/// Specifies the type of http method to use for a particular configured request.
	var method : HttpMethod { get }
    
	/// Defines the relative path where a resource is expected to be located relative to the base host defined in the RemoteConfig.
	var uri : String { get }
    
    /// Provides handling for adding parameters to a request. This makes use of the NetworkRequestModifier protocol and separate objects can be defined as needed for configuring requests based on the type of data being sent. See the ParameterModifiers subdirectory with the classes GETParamsModifier, FormDataModifier & PostParamsModifier for implementation examples of how this is used.
    ///
    /// - Parameter params: This is a dictionary of String:Any objects to be sent with a request. Most of the time the values of this dictionary will be either Strings or Data objects.
    /// - Returns: Sets up and returns a NetworkRequestModifier (will be either GETParamsModifier for GET requests or a FormDataModifier/PostParamsModifier for POST requests currently), this modifier is added to the 'requestModifiers' var for this protocol before all modifiers are then processed and used to configure the final URLRequest object when the 'urlRequest' function is called.
    func addParams(_ params: [String : Any]) -> NetworkRequestModifier
    
    /// Sets up and configures a URL request based on parameters and configurations defined in the other properties and functions in the implementing object of this protocol.
    ///
    /// - Parameters:
    ///   - config: This is an object specifying remote configuration data and parameters used to configure parameters of a URL request being sent to the remote api defined in the RemoteConfig object.
    ///   - params: Any POST/GET parameters that should be sent along with the URL request to the remote api.
    /// - Returns: Sets up and configures a URLRequest object using info defined in other properties and functions in the implementing object of this protocol.
    func urlRequest(forConfig config: RemoteConfig, params: [String : Any]?, headers: [String : String]?) -> URLRequest
}


extension NetworkRequestRouter {
    
    
    /// Provides default implementation for generating a URL request based on info specified in objects conforming to the 'ApiRouter' protocol.
    ///
    /// - Parameters:
    ///   - config: An instance of RemoteConfig specifying info necessary to connect to a remote host.
    ///   - params: A dictionary of parameters to be sent with a request. This can include Data objects as values, if that is the case then 'FormData' should be specified as the type of NetworkRequestModifier to use in generating the body for this request in the 'addParams' function of the implementing object. (See AppApiRouter object for an example)
    /// - Returns: Sets up and returns a configured URLRequest object to use in making a network request.
    func urlRequest(forConfig config: RemoteConfig, params: [String : Any]? = nil, headers: [String : String]? = nil) -> URLRequest {
        
        guard var hostComponents = config.baseURLComponents else {
            fatalError("Unable to make a request with a nil base url or path")
        }
        
        // set the path for this request
        hostComponents.path = uri
		
        guard let url = hostComponents.url else {
            fatalError("Unable to create a url with url components: \(hostComponents)")
        }
        
		var request = URLRequest(url: url)
		request.httpMethod = method.rawValue
        
        var modifiers = requestModifiers
        
        // if we have headers create a modifier for them
        if let headers = headers {
            let modifier = addHeaders(headers)
            modifiers.append(modifier)
        }
        
        // if we have parameters create a modifier for them (GET,POST,FormData POST)
        if let params = params {
            let modifier = addParams(params)
            modifiers.append(modifier)
        }
		
        // iterate modifiers and modify the request as specified
        for modifier in modifiers {
            modifier.configure(request: &request, with: config)
        }
        
        return request as URLRequest
	}
    
    
    /// Takes a dictionary of header values and creates a request modifier that
    /// will be used to add them to the outgoing request.
    ///
    /// - Parameter headers: A dictionary of headers to add to a request.
    /// - Returns: Returns a request modifier object that will be used to update the request.
    func addHeaders(_ headers: [String : String]) -> NetworkRequestModifier {
        return RequestHeaderModifier.init(headers)
    }
    
    /// If called on a GET request this function updates the request url with the provided parameters, otherwise it creates a json string representation of the passed in parameters and sets the request body with this data. 
    /// Generates a POST body, FormData body, GET request string or any custom provided behavior in a conforming class that overrides this implementation.
    /// Override this function in your conforming object to specify custom behaviors.
    func addParams(_ params: [String : Any]) -> NetworkRequestModifier {
        switch method {
        case .get:
            // return a get parameters modifier for all get requests
            return GetParamsModifier.init(params: params)
        default:
            // for all other requests return Post paramsModifier
            return PostParamsModifier.init(params: params)
        }
        
        
    }
}
