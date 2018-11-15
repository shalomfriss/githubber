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
    @IBOutlet weak var repoImage: UIImageView!
    
    //@IBOutlet var repoName:UILabel?
    //@IBOutlet var repoCount:UILabel?
    
    private var data:RepoEntry?
    
    func config(name:String, cnt:Int, data:RepoEntry) {
        
        var fileName = name.lowercased()
        if(fileName == "html") {
            fileName = "html5"
        }
        
        if(fileName == "css") {
            fileName = "css3"
        }
        
        var image = UIImage(named: "\(fileName)-plain")
        image = image?.maskWithColor(color: UIColor.magenta)
        self.repoImage.image = image
        self.insertSubview(self.repoImage, at: 0)
        self.repoName?.text = name
        self.repoCount?.text = "\(cnt)"
        self.data = data
        
        //self.repoImage.alpha = 0.3
        
        
        
    }
}
