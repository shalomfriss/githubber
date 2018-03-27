//
//  ViewController.swift
//  GitHubber
//
//  Created by user on 3/21/18.
//  Copyright © 2018 Shalom Friss. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK:- IB outlets and actions
    @IBOutlet weak var searchField:UITextField?
    @IBOutlet weak var searchButton:UIButton?
    
    @IBAction func searchButtonClicked(sender:UIButton) {
        
        
        //Preloader should go here
        guard let val = self.searchField?.text else { return }
        
        performSegue(withIdentifier: "repoListing", sender: sender)
        
        let dm = DataManager.instance
        dm.getRepos(owner: val)
        
        
    }
    
    //MARK:- UIViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        /*
        if let value = ProcessInfo.processInfo.environment["github_token"] {
            print("Github - \(value)")
        }
        else {
            print("No env token")
        }
        */
        
        //self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style:UIBarButtonItemStyle.plain, target:nil, action: nil)
        
        print("Loading repos")
        
        
        
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

