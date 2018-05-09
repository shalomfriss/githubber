//
//  ViewController.swift
//  GitHubber
//
//  Created by user on 3/21/18.
//  Copyright © 2018 Shalom Friss. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class ViewController: UIViewController {
    
    //MARK:- IB outlets and actions
    @IBOutlet weak var searchField:UITextField?
    @IBOutlet weak var searchButton:UIButton?
    @IBOutlet weak var settingsButton: UIButton!
    
    @IBAction func settingsClicked(_ sender: Any) {
        Alerter.getGithubToken()
    }
    
    var searchFieldDelegate:ACTextField = ACTextField()
    
    @IBAction func searchButtonClicked(sender:UIButton) {
        
        self.searchField?.resignFirstResponder()
        
        //Preloader should go here
        guard let val = self.searchField?.text else { return }
        
        self.searchField?.text = ""
        
        //"type:user in:login"
        
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
        
        let theToken: String? = KeychainWrapper.standard.string(forKey: "token")
        Config.GITHUB_TOKEN = theToken ?? ""
        if(Config.GITHUB_TOKEN == "") {
            Alerter.getGithubToken()
        }
        
        
        self.searchField?.delegate = self.searchFieldDelegate
        self.searchFieldDelegate.textField = self.searchField
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

