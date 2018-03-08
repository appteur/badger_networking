//
//  GETParamsModifier.swift
//  Networking
//
//  Created by Seth on 4/7/17.
//  Copyright © 2017 Seth. All rights reserved.
//

import Foundation

public class GetParamsModifier: NetworkRequestModifier {
    
    var params: [String : Any]
    
    init(params: [String : Any]) {
        self.params = params
    }
    
    func configure(request: inout URLRequest, with config: RemoteConfig) {
        // get the current base url path for our request
        guard let path = request.url?.absoluteString else {
            print("Failure to add GET parameters to request, unable to parse request path from url: \(String(describing: request.url))")
            return
        }
        // create our url components from the current base path
        var urlComponents = URLComponents.init(string: path)
        
        // this will be all our GET request query items
        var queryItems: [URLQueryItem] = []
        
        // enumerate our parameters and create query items to generate our url
        for (key,value) in params {
            if let value = value as? String {
                let query = URLQueryItem(name: key, value: value)
                queryItems.append(query)
            } else {
                print("Unable to add query item to GET request, value is not a string: \(value)")
            }
        }
        
        // update our url for this request
        urlComponents?.queryItems = queryItems
        request.url = urlComponents?.url
    }
}
