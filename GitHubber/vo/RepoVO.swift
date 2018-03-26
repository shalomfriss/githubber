//
//  Repo.swift
//  GitHubber
//
//  Created by user on 3/24/18.
//  Copyright © 2018 Shalom Friss. All rights reserved.
//

import Foundation

/*
    A repository
 */
class RepoVO {
    public var name:String              = ""
    public var description:String       = ""
    public var primaryLanguage:String   = ""
    public var url:String               = ""
    public var forks:Int                = 0
    public var stargazers:Int           = 0
    public var updatedAt:String         = ""
}
