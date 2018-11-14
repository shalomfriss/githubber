//
//  RepoTableCell.swift
//  GitHubber
//
//  Created by user on 3/26/18.
//  Copyright © 2018 Shalom Friss. All rights reserved.
//

import Foundation
import UIKit

class RepoCollectionCell:UICollectionViewCell
{
    public static let Identifier:String = "repoListingCollectionCell"
    
    @IBOutlet weak var repoName: UILabel!
    @IBOutlet weak var repoCount: UILabel!
    
    //@IBOutlet var repoName:UILabel?
    //@IBOutlet var repoCount:UILabel?
    
    private var data:RepoEntry?
    
    func config(name:String, cnt:Int, data:RepoEntry) {
        self.repoName?.text = name
        self.repoCount?.text = "\(cnt)"
        self.data = data
        
        
        
    }
}
