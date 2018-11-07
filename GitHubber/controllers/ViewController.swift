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
        
        let searchTerm = self.searchFieldDelegate.getSearchTerm()
        
        
        self.searchField?.text = ""
        
        //Reset and get some repos
        DispatchQueue.global(qos: .userInitiated).async {
            let dm = DataManager.instance
            dm.reset()
            dm.getRepos(owner: searchTerm)
        }
        
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
        
        //print("Getting token")
        
        /*
        var theToken = ""
        if let aToken = KeychainWrapper.standard.string(forKey: "token")
        {
            theToken = aToken
        }
        print("Token: \(theToken)")
        
        if(Config.GITHUB_TOKEN == "") {
            Config.GITHUB_TOKEN = theToken ?? ""
        }
        */
        
        //Check for token and ask
        if(NetworkManager.isConnectedToNetwork())
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
        
        
        
        self.searchField?.delegate = self.searchFieldDelegate
        self.searchFieldDelegate.textField = self.searchField
        
        let sampleClass = SampleClass()
        sampleClass.test = "custom test"
        PersistenceManager.archive(object: sampleClass, fileName: "test1", completion: { error in
            print("DONE")
            if(error == nil) {
               print("ARCHIVE OK")
            } else {
                print(error)
            }
        })
       
        
        if let newSampleClass:SampleClass =  PersistenceManager.unarchive(fileName: "test1") {
            print("DONE")
            print(newSampleClass)
        } else {
            print("FAIL")
            
        }
        
        
    }
    
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /******************************************************************/
    //UTILS
    /******************************************************************/
    //MARK:- Utils
    func tokenSavedMessage() {
        let message = Message(title: "Token saved!", backgroundColor: UIColor(red: 121/255, green: 178/255, blue: 0/255, alpha: 1.0) /* #79b200 */)
        Whisper.show(whisper: message, to: navigationController!, action: .show)
    }
    
    @objc func loadingComplete() {
        performSegue(withIdentifier: "repoListing", sender: nil)
    }
    
    
}

