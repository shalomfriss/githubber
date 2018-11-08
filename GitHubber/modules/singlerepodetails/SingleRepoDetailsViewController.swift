//
//  SingleRepoDetailsViewController.swift
//  GitHubber
//
//  Created by user on 11/7/18.
//  Copyright © 2018 Shalom Friss. All rights reserved.
//

import Foundation
import UIKit

class SingleRepoDetailsViewController:UIViewController {
    public var repo:RepoVO!
    
    @IBOutlet weak var readmeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.readmeLabel.translatesAutoresizingMaskIntoConstraints = false
        //self.readmeLabel.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //self.navigationController?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close", style: UIBarButtonItemStyle.plain, target: self, action: #selector(closeButtonClicked))
        
       // self.navigationItem.title = "Back"
        //navigationItem.backBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: nil)
        
        weak var weakself = self
        DispatchQueue.main.async {
            let txt = NSAttributedString(string: weakself?.repo.readme ?? "")
            weakself?.readmeLabel.attributedText = txt
            weakself?.title = "Repo details"
        }
        
        
        
        
    }
    @objc private func closeButtonClicked() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
