//
//  TokenAuth.swift
//  Networking
//
//  Created by Seth on 3/9/17.
//  Copyright © 2017 Arnott Industries, Inc. All rights reserved.
//

import Foundation


/// Provides example implementation of using token based authentication for URLRequests being sent to a remote api.
class TokenAuth: NetworkRequestModifier {
    
    func configure(request: inout URLRequest, with config: RemoteConfig) {
        guard let token = UserDefaults.standard.value(forKey: "com.sm.token") as? String else {
            print("ERROR:: -- TOKEN Auth -- Not setting token for request: [\(String(describing: request.url?.absoluteURL))] -- stored token not found")
            return
        }
        print("TOKEN AUTH: \(token)")
        request.addValue(token, forHTTPHeaderField: "Authorization")
    }
    
}
