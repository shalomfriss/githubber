//
//  Repo.swift
//  GitHubber
//
//  Created by user on 3/24/18.
//  Copyright © 2018 Shalom Friss. All rights reserved.
//

import Foundation
import RealmSwift

/*
    A repository
 */
class RepoVO:Object {
    @objc dynamic var name:String              = ""
    @objc dynamic var desc:String          = ""
    @objc dynamic var primaryLanguage:String   = ""
    @objc dynamic var url:String               = ""
    @objc dynamic var forks:Int                = 0
    @objc dynamic var stargazers:Int           = 0
    @objc dynamic var updatedAt:String         = ""
}
