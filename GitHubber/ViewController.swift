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
    
    
    /******************************************************************/
    //VIEWCONTROLLER METHODS
    /******************************************************************/
    //MARK:- UIViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Githubber"
        
        weak var weakSelf = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadingComplete), name: .LOADING_COMPLETE, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadingError), name: .LOADING_ERROR, object: nil)
        
        //Check for token and ask
        if(DataManager.isConnectedToNetwork())
        {
            if(Config.GITHUB_TOKEN == "") {
                Alerter.getGithubToken(complete: {
                    weakSelf?.tokenSavedMessage()
                }, strictModel: true)
            }
            
            DataManager.instance.checkToken(complete: {
                success in
                if(success == false) {
                    self.blockAndGetToken()
                }
            })
        }
        
        //setup delegates for ACTextField
        self.searchField?.delegate = self.searchFieldDelegate
        self.searchFieldDelegate.textField = self.searchField
        
    }
    
    override func viewDidAppear(_ animated:Bool) {
        //Whisper.show(whisper: "Welcome", to: self.navigationController, action: .show)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /******************************************************************/
    //EVENT HANDLERS / CALLBACKS
    /******************************************************************/
    @IBAction func searchButtonClicked(sender:UIButton) {
        //Get rid of the keyboard
        self.searchField?.resignFirstResponder()
        let searchTerm = self.searchFieldDelegate.getSearchTerm()
        DispatchQueue.main.async {
            self.searchField?.text = ""
        }
        
        Alerter.showPreloader()
        
        let dm = DataManager.instance
        dm.reset()
        dm.getRepos(owner: searchTerm)
    }
    
    //MARK:- Callbacks
    @IBAction func settingsClicked(_ sender: Any) {
        weak var weakSelf = self
        Alerter.getGithubToken(complete: {
            weakSelf?.tokenSavedMessage()
        })
    }
    
    /******************************************************************/
    //UTILS
    /******************************************************************/
    //MARK:- Utils
    
    /// Get the Github token
    func blockAndGetToken() {
        weak var weakSelf = self
        
        Alerter.getGithubToken(complete: {
            weak var weakSelf = weakSelf
            DataManager.instance.checkToken(complete: {
                success in
                if(success == false) {
                    weakSelf?.blockAndGetToken()
                }
            })
        }, strictModel: true)
    }
    
    func tokenSavedMessage() {
        let message = Message(title: "Token saved!", backgroundColor: UIColor(red: 121/255, green: 178/255, blue: 0/255, alpha: 1.0) /* #79b200 */)
        Whisper.show(whisper: message, to: navigationController!, action: .show)
    }
    
    @objc func loadingError() {
        Alerter.hidePreloader()
        let message = Message(title: "An error occured, please try again", backgroundColor: UIColor(red: 121/255, green: 178/255, blue: 0/255, alpha: 1.0) /* #79b200 */)
        
        Whisper.show(whisper: message, to: navigationController!, action: .show)
    }
    
    @objc func loadingComplete() {
        Alerter.hidePreloader()
        
        if(DataManager.instance.repositories.value.count == 0) {
            let message = Message(title: "No repos were found", backgroundColor: UIColor(red: 121/255, green: 178/255, blue: 0/255, alpha: 1.0) /* #79b200 */)
            
            Whisper.show(whisper: message, to: navigationController!, action: .show)
        } else {
            performSegue(withIdentifier: "repoListing", sender: nil)
        }
        
    }
    
    
}

