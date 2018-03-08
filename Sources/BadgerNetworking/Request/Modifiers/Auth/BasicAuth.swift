//
//  BasicAuth.swift
//  NetworkSuiteTest
//
//  Created by Seth on 2/3/17.
//  Copyright © 2017 Arnott Industries, Inc. All rights reserved.
//

import Foundation


/// Provides URL request modification logic that should be used to set basic auth headers on URLRequests being sent to a remote api.
class BasicAuth: NetworkRequestModifier {
    
    func configure(request: inout URLRequest, with config: RemoteConfig) {
        
//        guard let user = config.username, let password = config.password else {
//            print("YUGE ERROR --BasicAuth-- username/password not set in remote config. Unable to set auth header.")
//            return
//        }
//        
//        if let base64String = basicAuth(username: user, password: password) {
//            request.addValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
//        }
    }
    
    internal func basicAuth(username: String, password: String) -> String? {
        
        let toBase64 = "\(username):\(password)"
        
        guard let dataToBase64 = toBase64.data(using: .utf8) else {
            return nil
        }
        
        return dataToBase64.base64EncodedString()
    }
    
//    internal func addJWT(authValue: inout String) {
//        if let token = UserDefaults.standard.value(forKey: "token") as? String
//        {
//            authValue+=" JWT "+token
//        }
//    }
    
}
