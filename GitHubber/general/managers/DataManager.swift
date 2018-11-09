//
//  DataManager.swift
//  GitHubber
//
//  Created by user on 3/24/18.
//  Copyright © 2018 Shalom Friss. All rights reserved.
//

import Foundation
import Apollo
import RxSwift
import RxCocoa
import RealmSwift
import SystemConfiguration

/**
 DataManager handles retrieving data from Github
 */
class DataManager {
    
    //MARK:- Apollo related
    internal var apollo: ApolloClient?   //The Apollo client
    internal let disposeBag = DisposeBag()   //RXSwift dispose bag
    public var repositories:Variable<[RepoEntry]> = Variable([])    //the main repo container
    public var languageRepos:Variable<[RepoVO]> = Variable([])      //One of the arrays in repositories
    
    internal var totalRepos:Int = 0
    
    //A temporary store for the repos
    internal var tempRepos = [String:[RepoVO]]()
    
    //MARK:- Singleton related
    internal static var _instance:DataManager = DataManager(123) //the instance
    public static var instance:DataManager {
        get {
            return _instance
        }
    }
    
    internal var currentOwner:String = ""
    internal var tokenIsValid = true
    
    //MARK:- Initialization
    init() {
        assertionFailure("Cannot instantiate DataManager directly use DataManager.instance")
    }
    
    init(_ check:Int) {
        if(check != 123) {
            assertionFailure("Cannot instantiate DataManager directly use DataManager.instance")
        }
        
        self.apollo = {
            let configuration = URLSessionConfiguration.default
            configuration.httpAdditionalHeaders = ["Authorization": "Bearer \(Config.GITHUB_TOKEN)"]
            let url = URL(string: Config.GITHUB_URL)!
            return ApolloClient(networkTransport: HTTPNetworkTransport(url: url, configuration: configuration))
        }()
    }
    
    
    
    public func reconfigure() {
        self.apollo = {
            let configuration = URLSessionConfiguration.default
            configuration.httpAdditionalHeaders = ["Authorization": "Bearer \(Config.GITHUB_TOKEN)"]
            let url = URL(string: Config.GITHUB_URL)!
            return ApolloClient(networkTransport: HTTPNetworkTransport(url: url, configuration: configuration))
        }()
        
        self.reset()
    }
    
    //MARK:- API
    /**
     Reset everything
     */
    func reset() {
        self.tempRepos = [String:[RepoVO]]()
        self.repositories.value.removeAll()
    }
    
    public func setTokenIsValid(val:Bool) {
        self.tokenIsValid = val
    }
    
    internal func tokenError() {
        if(self.tokenIsValid == false){
            return
        }
        
        self.setTokenIsValid(val: false)
        Alerter.alert(title: "Error", msg: "Could not fetch github data.  Please make sure your token is set correctly, or try again later")
    }
    
    internal func tokenSuccess() {
        self.setTokenIsValid(val: true)
    }
    
    
    
    
    /**
     Get multiple name suggestions (first 100)
     */
    func checkToken(complete:@escaping (Bool) -> Void) {
        //Had to be created this way according to Github
        let qString = "type:user facebook in:login"
        
        self.apollo?.fetch(query:  UserNameQuery(queryString: qString)) { result, error
            in
            
            if(error != nil)
            {
                complete(false)
                return
            }
            
            complete(true)
        }
    }
    
    /**
     Restore the owners repos from the cache (realm)
     @param owner:String - The owner of the repos to restore
     */
    func restoreFromCache(owner:String) {
        do {
            let realm = try Realm()
            let reps = realm.objects(RepoEntryList.self).filter({$0.username == owner})
            if(reps.count > 0) {
                let entries = reps.first
                
                self.repositories.value.removeAll()
                for rep in entries!.repoEntries {
                    self.repositories.value.append(rep)
                }
            }
            
            NotificationCenter.default.post(name: .LOADING_COMPLETE, object: nil)
        } catch {
            fatalError("Could not access Realm")
        }
        
    }
    
    
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability! , &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
}

