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
    
    
    @IBOutlet weak var repoName: UILabelPadded!
    @IBOutlet weak var repoCount: UILabelPadded!
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
        print("image")
        print(image)
        //rgb(150, 175, 103)
        //rgb(88, 235, 207)
        image = image?.maskWithColor(color: UIColor(displayP3Red: 0/255, green: 0/255, blue: 0/255, alpha: 1))
        
        self.repoImage.image = image
        self.insertSubview(self.repoImage, at: 0)
        self.repoName?.text = name
        self.repoCount?.text = "\(cnt)"
        self.data = data
        
        //#33CAFD
        //rgb(51, 202, 253)
        self.backgroundColor = UIColor(displayP3Red: 150/255, green: 175/255, blue: 103/255, alpha: 0.5)
        self.repoCount.textColor = UIColor.white
        
        self.repoName.insets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 5)
        self.repoCount.insets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 5)
        self.repoImage.alpha = 0.6
        
    }
}
