//
//  SingleRepoDetailsViewController.swift
//  GitHubber
//
//  Created by user on 11/7/18.
//  Copyright © 2018 Shalom Friss. All rights reserved.
//

import Foundation
import UIKit
import Down

class SingleRepoDetailsViewController:UIViewController {
    public var repo:RepoVO!
    
    @IBOutlet weak var readme: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Repo details"
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        
        
        let down = Down(markdownString: self.repo.readme)
        weak var weakself = self
        DispatchQueue.main.async {
            do{
                weakself?.readme.attributedText = try down.toAttributedString()
            } catch {
                print(error)
            }
        }
    }
    
    @objc private func closeButtonClicked() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
