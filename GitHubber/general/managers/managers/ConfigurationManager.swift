//
//  ConfigurationManager.swift
//  GitHubber
//
//  Created by user on 11/5/18.
//  Copyright © 2018 Shalom Friss. All rights reserved.
//

import Foundation

enum ConfigurationEvents {
    
}

enum ConfigurationError:Error {
    case couldNotLoadConfigFile
}

/// Loads configuration files which are stored on disk as plist
class ConfigurationManager {
    static private var config = [String:NSDictionary]()
    
    
    /// Load a configuration from file using the fileName and storing it in memory with configName
    ///
    /// - Parameters:
    ///   - fileName:String - A plist file without the .plist extension
    ///   - configName:String
    /// - Throws:
    class func loadConfig(fileName:String, configName:String) throws {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "plist") else {
            throw ConfigurationError.couldNotLoadConfigFile
        }
        let dict = NSDictionary(contentsOfFile: path)
        config[configName] = dict
    }
    
    class func getConfig(configName:String) -> NSDictionary? {
        return config[configName]
    }
}
