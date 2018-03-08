//
//  RemoteConfig.swift
//  NetworkSuiteTest
//
//  Created by Seth on 2/3/17.
//  Copyright © 2017 Arnott Industries Inc. All rights reserved.
//

import Foundation


/// Encapsulates configuration data used to setup and configure a network session, or requests to a given host.
public struct RemoteConfig {
    
    /// URL components specifying the base url, created from the 'baseURL' string passed in on struct initialization.
    public var baseURLComponents: URLComponents?
    
    /// Provides the base path for the configured host. Pulls from the baseURLComponents property.
    public var basePath: String? {
        return baseURLComponents?.url?.absoluteString
    }
    
    /// Provides same data as 'basePath' property, except in URL form instead of string form.
    public var baseURL: URL? {
        return baseURLComponents?.url
    }
    
    /// Provides init functionality for use when specific values are to be used to configure an instance.
    ///
    /// - Parameters:
    ///   - baseURL: The baseURL path to use for setting up a configuration instance.
    public init(basePath: String) {
        self.baseURLComponents = URLComponents.init(string: basePath)
    }
}
