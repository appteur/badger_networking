//
//  CustomRequestHeaderProvider.swift
//  NetworkSuiteTest
//
//  Created by Seth on 2/3/17.
//  Copyright © 2017 Arnott Industries, Inc. All rights reserved.
//

import Foundation


/// Defines an interface to implement in objects that provide customization of URLRequest objects when they are being generated/configured before being sent to a remote api.
protocol NetworkRequestModifier {
    
    /// Conforming objects need to implement this function and provide logic to configure the request in any way necessary. This could be modifying headers, setting the body or other valid functionality to customize a URLRequest object before sending to a remote api.
    ///
    /// - Parameters:
    ///   - request: This is the request to modify. By using inout the request is mutable and no value needs to be returned. Implementing objects should modify this request as desired.
    ///   - config: This provides info about the base host and username/password info that may be needed to configure requests in some cases.
    func configure(request: inout URLRequest, with config: RemoteConfig)
}
