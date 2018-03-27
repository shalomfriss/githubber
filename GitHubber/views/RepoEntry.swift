//
//  RepoEntry.swift
//  GitHubber
//
//  Created by user on 3/26/18.
//  Copyright © 2018 Shalom Friss. All rights reserved.
//

import Foundation

class RepoEntry {
    public var language:String = ""
    public var repos = [RepoVO]()
    public var count:Int {
        get {
            return repos.count
        }
    }
}
