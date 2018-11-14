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
    
    public var viewModel:SingleRepoDetailsViewModel = SingleRepoDetailsViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Repo details"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let down = Down(markdownString: self.repo.readme)
        weak var weakself = self
        DispatchQueue.main.async {
            do{
                var attribString = try down.toAttributedString()
                attribString = attribString.attributedStringWithResizedImages(with: UIScreen.main.bounds.width)
                weakself?.readme.attributedText = attribString
            } catch {
                print(error)
            }
        }
    }
    
    @objc private func closeButtonClicked() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
