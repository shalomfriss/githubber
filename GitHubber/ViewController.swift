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
        
        if(Config.GITHUB_TOKEN == "") {
            Alerter.getGithubToken()
        }
        
        self.searchField?.delegate = self.searchFieldDelegate
        self.searchFieldDelegate.textField = self.searchField
        NotificationCenter.default.addObserver(self, selector: #selector(self.possibilitiesUpdated), name: NSNotification.Name(rawValue: "possibilitiesUpdated"), object: nil)
       
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    @objc func possibilitiesUpdated(notfication: NSNotification) {
        self.searchFieldDelegate.possibilitiesUpdated(notfication: notfication)
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

