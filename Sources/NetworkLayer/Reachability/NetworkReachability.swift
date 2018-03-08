//
//  NetworkReachability.swift
//  NetworkSuiteTest
//
//  Created by Seth on 2/3/17.
//  Copyright © 2017 Arnott Industries, Inc. All rights reserved.
//

import Foundation

class NetworkReachability: NetworkAccessibilityProvider {
    
    var status: NetworkAccessibilityStatus = .unreachable
    
    internal var host: String?
    internal var reachability: Reachability?
    
    deinit
    {
        self.stopNotifier()
    }
    
    init(host: String) {
        configure(for: host)
    }
    
    func updateReachabilityStatus(reachability: Reachability) {
        print("Reachability - [\(String(describing: host))] status: \(reachability.currentReachabilityString)")
        switch reachability.currentReachabilityStatus {
        case .notReachable:     status = .unreachable;          break
        case .reachableViaWWAN: status = .reachableViaCellular; break
        case .reachableViaWiFi: status = .reachableViaWifi;     break
        }
    }
    
    
    // MARK: Notifiers
    func startNotifier()
    {
        print("Reachability - start notifier")
        do {
            try reachability?.startNotifier()
        } catch {
            print("Reachability - Unable to start notifier")
            return
        }
    }
    
    func stopNotifier()
    {
        print("Reachability - stop notifier")
        reachability?.stopNotifier()
        reachability = nil
    }
    
    // MARK: Configuration
    func configure(for host: String) {
        
        guard host != self.host else {
            print("Reachability - Already configured for host: \(host) ... bailing")
            return
        }
        
        self.host = host
        
        // stop notifier for current reachability
        stopNotifier()
        
        // update status
        status = .unreachable
        
        // update reachability
        reachability = Reachability.init(hostname: host)
        
        weak var weakself = self
        // configure handlers for changes in reachability status
        reachability?.whenReachable = { reachability in
            weakself?.updateReachabilityStatus(reachability: reachability)
        }
        reachability?.whenUnreachable = { reachability in
            weakself?.updateReachabilityStatus(reachability: reachability)
        }
        
        // kick off reachability
        startNotifier()
    }
}
