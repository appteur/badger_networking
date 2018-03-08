//
//  PostParamsURLEncodedModifier.swift
//  EmojiAppMaker
//
//  Created by Seth on 7/18/17.
//  Copyright © 2017 Arnott Industries, Inc. All rights reserved.
//

import Foundation

public class PostParamsURLEncodedModifier: NetworkRequestModifier {
    
    var postParams: [String : Any]?
    var postData: Data?
    
    init(params: [String : Any]) {
        postParams = params
        toFormEncoding()
    }
    
    func toFormEncoding() {
        guard let postParams = postParams else {
            return
        }
        
        var paramsStr = ""
        
        for (key,value) in postParams {
            paramsStr = paramsStr+"\(key)=\(value)&"
        }
        
        // try converting to json
        postData = paramsStr.data(using: .utf8)
        
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
        request.addValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
    }
}
