//
//  Alerter.swift
//  GitHubber
//
//  Created by user on 3/26/18.
//  Copyright © 2018 Shalom Friss. All rights reserved.
//

import Foundation
import UIKit
import SwiftKeychainWrapper

class Alerter {
    static var preloaderShowing:Bool = false
    static var alert:UIAlertController!
    
    static public func getGithubToken(complete: @escaping () -> Void, strictModel:Bool = false) {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            if(Alerter.alert != nil) {
                Alerter.alert.dismiss(animated: false, completion: nil)
                Alerter.alert = nil
            }
            
            Alerter.alert = UIAlertController(title: "Github token", message: "Please paste your github personal token", preferredStyle: .alert)
            
            Alerter.alert.addTextField { (textField) in textField.text = "" }
            
            if(strictModel == false) {
                Alerter.alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { _ in
                    Alerter.alert.dismiss(animated: true, completion: nil)
                    Alerter.alert = nil
                }))
            }
            
            
            Alerter.alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                let textField = Alerter.alert.textFields?[0]
                let token = textField?.text
                
                print("Got token")
                print(token!)
                
                let saveSuccessful: Bool = KeychainWrapper.standard.set(token!, forKey: "token")
                
                if(saveSuccessful == false) {
                    Alerter.alert(title: "Error", msg: "Could not save your token locally")
                    return
                }
                
                if(token != nil) {
                    Config.GITHUB_TOKEN = token!
                    print(Config.GITHUB_TOKEN)
                }
                else {
                    Alerter.alert(title: "Error", msg: "An error occured please try again")
                }
                
                DataManager.instance.reconfigure()
                
                Alerter.alert.dismiss(animated: true, completion: nil)
                Alerter.alert = nil
                
                complete()
                
                
            }))
            
            topController.present(Alerter.alert, animated: true, completion: nil)
        }
        
        
        
    }
    static public func alert(title:String, msg:String) {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            if(Alerter.alert != nil){
                Alerter.alert.dismiss(animated: false, completion: nil)
                Alerter.alert = nil
            }
            
            Alerter.alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
            
            Alerter.alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: { _ in
                Alerter.alert.dismiss(animated: true, completion: nil)
                Alerter.alert = nil
            }))
            
            topController.present(Alerter.alert, animated: false, completion: nil)
        }
    }
    
    
    /******************************************************************/
    //PRELOADER
    /******************************************************************/
    static public func showPreloader() {
        if(Alerter.preloaderShowing == true) {
            return
        }
        Alerter.preloaderShowing = true
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            let alert = UIAlertController(title: nil, message: "One moment please...", preferredStyle: .alert)
            let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
            loadingIndicator.hidesWhenStopped = true
            loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            loadingIndicator.startAnimating();
            alert.view.addSubview(loadingIndicator)
            topController.present(alert, animated: false, completion: nil)
        }
    }
    
    static public func hidePreloader() {
        if(Alerter.preloaderShowing == false) {
            return
        }
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            topController.dismiss(animated: false, completion: nil)
        }
        Alerter.preloaderShowing = false
    }
    
}
