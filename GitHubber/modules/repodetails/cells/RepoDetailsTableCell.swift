//
//  RepoTableCell.swift
//  GitHubber
//
//  Created by user on 3/26/18.
//  Copyright © 2018 Shalom Friss. All rights reserved.
//

import Foundation
import UIKit

class RepoDetailsTableCell:UITableViewCell
{
    public static let Identifier:String = "repoDetailsTableCell"
    
    @IBOutlet var repoName:UILabel?
    @IBOutlet var repoDescription:UILabel?
    @IBOutlet var stars:UILabel?
    @IBOutlet var forks:UILabel?
    @IBOutlet var updated:UILabel?
    
    public var repo:RepoVO?
    
    func config(name:String, desc:String, stars:Int, forks:Int, updated:String) {
        self.repoName?.text         = name
        self.repoDescription?.text  = desc
        self.stars?.text            = "Stars: \(stars)"
        self.forks?.text            = "Forks: \(forks)"
        self.updated?.text          = "Updated: " + updated
    }
}

