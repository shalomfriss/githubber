//
//  ViewController.swift
//  GitHubber
//
//  Created by user on 3/21/18.
//  Copyright © 2018 Shalom Friss. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    
    //MARK:- IB outlets and actions
    @IBOutlet weak var searchField:UITextField?
    @IBOutlet weak var searchButton:UIButton?
    
    var notificationToken: NotificationToken!
    var realm: Realm!
    
    @IBAction func searchButtonClicked(sender:UIButton) {
        
        //Preloader should go here
        guard let val = self.searchField?.text else { return }
        
        self.searchField?.text = ""
        
        let dm = DataManager.instance
        dm.reset()
        dm.getRepos(owner: val)
        
    }
    
    @objc func loadingComplete() {
        performSegue(withIdentifier: "repoListing", sender: nil)
    }
    
    //MARK:- UIViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadingComplete), name: .LOADING_COMPLETE, object: nil)
        
        let realm = try! Realm()
        let repoEntries = realm.objects(RepoEntryList.self)
        print("REALM")
        print(repoEntries)
        
        Alerter.getGithubToken()
        
        
        /*
        if let value = ProcessInfo.processInfo.environment["github_token"] {
            print("Github - \(value)")
        }
        else {
            print("No env token")
        }
        */
        
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        notificationToken.invalidate()
    }

}

