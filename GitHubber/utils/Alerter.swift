//
//  Alerter.swift
//  GitHubber
//
//  Created by user on 3/26/18.
//  Copyright © 2018 Shalom Friss. All rights reserved.
//

import Foundation
import UIKit

class Alerter {
    static var preloaderShowing:Bool = false
    
    static public func getGithubToken() {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            let alert = UIAlertController(title: "Github token", message: "Please paste your github personal token", preferredStyle: .alert)
            alert.addTextField { (textField) in textField.text = "" }
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                let textField = alert?.textFields?[0]
                let token = textField?.text
                if(token != nil) {
                    Config.GITHUB_TOKEN = token!
                }
                else {
                    Alerter.alert(title: "Error", msg: "An error occured please try again")
                }
                
                
            }))
            
            topController.present(alert, animated: true, completion: nil)
        }
        
        
        
    }
    static public func alert(title:String, msg:String) {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            topController.present(alert, animated: false, completion: nil)
        }
    }
    
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
