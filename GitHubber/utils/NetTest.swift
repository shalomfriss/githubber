//
//  NetTest.swift
//  GitHubber
//
//  Created by user on 3/28/18.
//  Copyright © 2018 Shalom Friss. All rights reserved.
//

import Foundation
import SystemConfiguration

public class NetTest {
    
    static func isConnectedToNetwork() -> Bool {
        
        guard let reachability = SCNetworkReachabilityCreateWithName(nil, "www.google.com") else { return false }
        
        var flags = SCNetworkReachabilityFlags()
        SCNetworkReachabilityGetFlags(reachability, &flags)
        
        if !isNetworkReachable(with: flags) {
            return false
        }
        let isReachable: Bool = flags.contains(.reachable)
        
        #if os(iOS)
            // It's available just for iOS because it's checking if the device is using mobile data
            if flags.contains(.isWWAN) {
                // Device is using mobile data
                return true
            }
        #endif
        
        return isReachable
    }
    
    static func isNetworkReachable(with flags: SCNetworkReachabilityFlags) -> Bool {
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        let canConnectAutomatically = flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic)
        let canConnectWithoutUserInteraction = canConnectAutomatically && !flags.contains(.interventionRequired)
        
        return isReachable && (!needsConnection || canConnectWithoutUserInteraction)
    }
    
    
}
