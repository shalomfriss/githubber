//
//  RepoEntry.swift
//  GitHubber
//
//  Created by user on 3/26/18.
//  Copyright © 2018 Shalom Friss. All rights reserved.
//

import Foundation
import RealmSwift


class RepoEntry: Object {
    @objc dynamic var language:String = ""
    var repos = List<RepoVO>()//[RepoVO]()
    @objc dynamic public var count:Int {
        get {
            return repos.count
        }
    }
}
