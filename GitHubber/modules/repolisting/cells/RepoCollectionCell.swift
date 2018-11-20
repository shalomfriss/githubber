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
    private lazy var gradient: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.yellow.cgColor, UIColor.orange.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = self.bounds
        return gradientLayer
    }()
    
    public static let Identifier:String = "repoListingCollectionCell"
    
    
    @IBOutlet weak var repoName: UILabelPadded!
    @IBOutlet weak var repoCount: UILabelPadded!
    @IBOutlet weak var repoImage: UIImageView!
    
    //@IBOutlet var repoName:UILabel?
    //@IBOutlet var repoCount:UILabel?
    
    private var data:RepoEntry?
    
    func config(name:String, cnt:Int, data:RepoEntry) {
        
        self.layer.insertSublayer(self.gradient, at: 0)
        
        var fileName = name.lowercased()
        if(fileName == "html") {
            fileName = "html5"
        }
        
        if(fileName == "css") {
            fileName = "css3"
        }
        
        
        var image = UIImage(named: "\(fileName)-plain")
        print("image")
        print(fileName)
        print(image)
        //rgb(150, 175, 103)
        //rgb(88, 235, 207)
        image = image?.maskWithColor(color: UIColor(displayP3Red: 0/255, green: 0/255, blue: 0/255, alpha: 1))
        
        self.repoImage.image = image
        self.insertSubview(self.repoImage, at: 1)
        self.repoName?.text = name
        self.repoCount?.text = "\(cnt)"
        self.data = data
        
        //#33CAFD
        //rgb(51, 202, 253)
        //self.backgroundColor = UIColor(displayP3Red: 150/255, green: 175/255, blue: 103/255, alpha: 0.5)
        //self.repoCount.textColor = UIColor.black
        
        self.repoName.insets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 8)
        self.repoCount.insets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 8)
        self.repoImage.alpha = 0.6
        
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 4
        self.layer.cornerRadius = 8 // optional
        
        self.frame.size.width = 120
        self.frame.size.height = 120
    }
}
