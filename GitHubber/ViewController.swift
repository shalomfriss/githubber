//
//  ViewController.swift
//  GitHubber
//
//  Created by user on 3/21/18.
//  Copyright © 2018 Shalom Friss. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Whisper


class ViewController: UIViewController {
    
    var searchFieldDelegate:ACTextField = ACTextField()
    
    //MARK:- IB outlets and actions
    @IBOutlet weak var searchField:UITextField?
    @IBOutlet weak var searchButton:UIButton?
    @IBOutlet weak var settingsButton: UIButton!
    
    @IBAction func settingsClicked(_ sender: Any) {
        weak var weakSelf = self
        Alerter.getGithubToken(complete: {
            weakSelf?.tokenSavedMessage()
        })
    }
    
    @IBAction func searchButtonClicked(sender:UIButton) {
        
        //Get rid of the keyboard
        self.searchField?.resignFirstResponder()
        
        //Preloader should go here
        
        //Uh, the search field should be there
        guard let val = self.searchField?.text else { return }
        self.searchField?.text = ""
        
        //Reset and get some repos
        let dm = DataManager.instance
        dm.reset()
        dm.getRepos(owner: val)
        
    }
    
    
    
    /******************************************************************/
    //VIEWCONTROLLER METHODS
    /******************************************************************/
    //MARK:- UIViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        weak var weakSelf = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadingComplete), name: .LOADING_COMPLETE, object: nil)
        
        print("Getting token")
        var theToken: String = KeychainWrapper.standard.string(forKey: "token")!
        print("Token: \(theToken)")
        
        if(Config.GITHUB_TOKEN == "") {
            Config.GITHUB_TOKEN = theToken ?? ""
        }
        
        if(Config.GITHUB_TOKEN == "") {
            Alerter.getGithubToken(complete: {
                weakSelf?.tokenSavedMessage()
            }, strictModel: true)
        }
        
        
        self.searchField?.delegate = self.searchFieldDelegate
        self.searchFieldDelegate.textField = self.searchField
        
        
        DataManager.instance.checkToken(complete: {
            success in
            if(success == false) {
                self.blockAndGetToken()
            }
        })
    }
    
    func blockAndGetToken() {
        weak var weakSelf = self
        
        Alerter.getGithubToken(complete: {
            DataManager.instance.checkToken(complete: {
                success in
                if(success == false) {
                    self.blockAndGetToken()
                }
            })
        }, strictModel: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /******************************************************************/
    //UTILS
    /******************************************************************/
    //MARK:- Utils
    func tokenSavedMessage() {
        print("Token saved")
        let message = Message(title: "Token saved!", backgroundColor: UIColor(red: 121/255, green: 178/255, blue: 0/255, alpha: 1.0) /* #79b200 */)
        Whisper.show(whisper: message, to: navigationController!, action: .show)
    }
    
    @objc func loadingComplete() {
        performSegue(withIdentifier: "repoListing", sender: nil)
    }
    
    
}

