//
//  CountryListController.swift
//  ShellAssignment
//
//  Created by Avinash on 1/31/19.
//  Copyright © 2018 Capgemini. All rights reserved.
//

import UIKit

class ReachabilityManager: NSObject {
    static let shared = ReachabilityManager()
    private override init() {}
    // Boolean to track network reachability
    var isNetworkAvailable : Bool {
        return (reachability.connection == .wifi) || (reachability.connection == .cellular)
    }
    
    // 5. Reachability instance for Network status monitoring
    let reachability = Reachability(hostname: "google.com")!
    
    /// Starts monitoring the network availability status
    func startMonitoring() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reachabilityChanged(note:)),
                                               name: .reachabilityChanged,
                                               object: reachability)
        
        do{
            try reachability.startNotifier()
        } catch {
            debugPrint("Could not start reachability notifier")
        }
    }
    
    /// Stops monitoring the network availability status
    func stopMonitoring(){
        reachability.stopNotifier()
    }
    
    
    @objc func reachabilityChanged(note: Notification) {

            let reachability = note.object as! Reachability
            switch reachability.connection {
            case .none:
                debugPrint("Network became unreachable")
            case .wifi:
                debugPrint("Network reachable through WiFi")
            case .cellular:
                debugPrint("Network reachable through Cellular Data")
            }
  
    }
}

