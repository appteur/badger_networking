//
//  PostParamsModifier.swift
//  Networking
//
//  Created by Seth on 3/6/17.
//  Copyright © 2017 Arnott Industries, Inc. All rights reserved.
//

import Foundation

public class PostParamsModifier: NetworkRequestModifier {
    
    var postParams: [String : Any]?
    var postData: Data?
    
    init(params: [String : Any]) {
        postParams = params
        toJson()
    }
    
    func toJson() {
        guard let postParams = postParams else {
            return
        }
        
        // try converting to json
        postData = try? JSONSerialization.data(withJSONObject: postParams, options: [])
        
        guard let data = postData else {
            print("Failed to convert post vars: \(postParams)")
            return
        }
        
        if let debug = String.init(data: data, encoding: .utf8) {
            print("Sending parameters: \(debug)")
        }
    }
    
    
    func configure(request: inout URLRequest, with config: RemoteConfig) {
        guard let body = postData else {
            return
        }
        
        request.httpBody = body
        request.addValue("\(body.count)", forHTTPHeaderField: "Content-Length")
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
    }
}
