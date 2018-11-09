//
//  ConfigurationManagerTests.swift
//  GitHubberTests
//
//  Created by user on 11/8/18.
//  Copyright © 2018 Shalom Friss. All rights reserved.
//

import XCTest

class ConfigurationManagerTests: XCTestCase {

    func testConfigLoad() {
        do {
            try ConfigurationManager.loadConfig(fileName: "GlobalConfig", configName: "testConfig")
            if let config = ConfigurationManager.getConfig(configName: "testConfig") {
                XCTAssertEqual(config["github_url"] as! String, "https://api.github.com/graphql")
            } else {
                XCTAssert(false)
            }
        } catch {
            XCTAssert(false)
        }
    }
    
}
