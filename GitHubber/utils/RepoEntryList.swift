//
//  RepoEntryList.swift
//  GitHubber
//
//  Created by user on 3/29/18.
//  Copyright © 2018 Shalom Friss. All rights reserved.
//

import Foundation
import RealmSwift

class RepoEntryList:Object {
    @objc dynamic var username = ""
    var repoEntries = List<RepoEntry>()
}
