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

/**
 DataManager handles retrieving data from Github
 */
class DataManager {
    
    //MARK:- Apollo related
    private var apollo: ApolloClient?   //The Apollo client
    private let disposeBag = DisposeBag()   //RXSwift dispose bag
    public var repositories:Variable<[RepoEntry]> = Variable([])    //the main repo container
    public var languageRepos:Variable<[RepoVO]> = Variable([])      //One of the arrays in repositories
    
    private var totalRepos:Int = 0
    
    //A temporary store for the repos
    private var tempRepos = [String:[RepoVO]]()
    
    //MARK:- Singleton related
    private static var _instance:DataManager = DataManager(123) //the instance
    public static var instance:DataManager {
        get {
            return _instance
        }
    }
    
    private var currentOwner:String = ""
    private var tokenIsValid = true
    
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
    
    public func setTokenIsValid(val:Bool) {
        self.tokenIsValid = val
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
    
    /**
     Get the total number of repos
     @param owner:String - The owner who's repos to search
     */
    func getRepoCount(owner:String) {
        
        Alerter.showPreloader()
        self.apollo?.fetch(query: RepoCountQuery(user: owner)){ [weak self] result, error
            in
            
            if(error != nil)
            {
                self?.tokenError()
                return
            }
            
            let _ = self
            self?.tokenSuccess()
            
            let count = result?.data?.repositoryOwner?.repositories.totalCount ?? 0
            self?.totalRepos = count
            Alerter.hidePreloader()
        }
    }
    
    /**
     Restore the owners repos from the cache (realm)
     @param owner:String - The owner of the repos to restore
     */
    func restoreFromCache(owner:String) {
        let realm = try! Realm()
        let reps = realm.objects(RepoEntryList.self).filter({$0.username == owner})
        if(reps.count > 0) {
            let entries = reps.first
            
            self.repositories.value.removeAll()
            for rep in entries!.repoEntries {
                self.repositories.value.append(rep)
            }
        }
        
        NotificationCenter.default.post(name: .LOADING_COMPLETE, object: nil)
    }
    
    
    /**
     Get the repos of the mentioned owner
     @param owner:String - A string describing the owner
     */
    func getRepos(owner:String) {
        
        let connected = NetworkManager.isConnectedToNetwork()
        if(connected == false) {
            self.restoreFromCache(owner: owner)
            NotificationCenter.default.post(name: .LOADING_COMPLETE, object: nil)
            return
        }
        
        self.currentOwner = owner
        
        if(self.tokenIsValid == false) {
            self.restoreFromCache(owner: owner)
            return
        }
        
        Alerter.showPreloader()
        self.apollo?.fetch(query:  ReposQuery(user: owner)) { [weak self] result, error
            in
            
            if(error != nil)
            {
                Alerter.hidePreloader()
                self?.tokenError()
                return
            }
            
            let _ = self
            self?.tokenSuccess()
            
            result?.data?.repositoryOwner?.repositories.edges?.forEach { edge in
                guard let repo = edge?.node else { return }
                
                //Create a value object for the repo, this gives us an easy way to deal with a repo
                //Representation and also is self-documenting
                let repovo = RepoVO()
                repovo.name = repo.name
                repovo.desc = repo.description ?? ""
                repovo.primaryLanguage = repo.primaryLanguage?.name ?? "Unknown"
                repovo.forks = repo.forks.totalCount
                repovo.stargazers = repo.stargazers.totalCount
                repovo.updatedAt = repo.updatedAt
                repovo.url = repo.url
                repovo.readme = (repo.object?.snapshot["text"] ?? "" ) as! String
                
                print("----------------------------------------------")
                print((repo.object?.snapshot["text"] ?? "" ) as! String)
                
                //Github has their own language detection so no need to massage the language name
                if(self?.tempRepos[repovo.primaryLanguage] == nil) {
                    self?.tempRepos[repovo.primaryLanguage] = [RepoVO]()
                }
                
                self?.tempRepos[repovo.primaryLanguage]?.append(repovo)
            }
            
            let hasNext = result?.data?.repositoryOwner?.repositories.pageInfo.hasNextPage
            if(hasNext == true) {
                if let cursor = result?.data?.repositoryOwner?.repositories.pageInfo.endCursor {
                    self?.getReposContinued(owner: owner, cursor: cursor)
                }
                else {
                    Alerter.hidePreloader()
                    self?.sortRepos()
                    NotificationCenter.default.post(name: .LOADING_COMPLETE, object: nil)
                }
            }
            else {
                Alerter.hidePreloader()
                self?.sortRepos()
                NotificationCenter.default.post(name: .LOADING_COMPLETE, object: nil)
            }
            
        }
        
    }
    
    //MARK:- API
    /**
     Get the repos of the mentioned owner
     @param owner:String - A string describing the owner
     */
    func getReposContinued(owner:String, cursor:String) {
        
        print("Get more repos")
        Alerter.showPreloader()
        self.apollo?.fetch(query:  ReposContinueQuery(user: owner, cursor: cursor)) { [weak self] result, error
            in
            
            if(error != nil)
            {
                Alerter.hidePreloader()
                self?.tokenError()
                return
            }
            
            let _ = self
            self?.tokenSuccess()
            
            result?.data?.repositoryOwner?.repositories.edges?.forEach { edge in
                guard let repo = edge?.node else { return }
                
                //Create a value object for the repo, this gives us an easy way to deal with a repo
                //Representation and also is self-documenting
                let repovo = RepoVO()
                repovo.name = repo.name
                repovo.desc = repo.description ?? ""
                repovo.primaryLanguage = repo.primaryLanguage?.name ?? "Unknown"
                repovo.forks = repo.forks.totalCount
                repovo.stargazers = repo.stargazers.totalCount
                repovo.updatedAt = repo.updatedAt
                repovo.url = repo.url
                
                //Github has their own language detection so no need to massage the language name
                if(self?.tempRepos[repovo.primaryLanguage] == nil) {
                    self?.tempRepos[repovo.primaryLanguage] = [RepoVO]()
                }
                
                self?.tempRepos[repovo.primaryLanguage]?.append(repovo)
            }
            
            let hasNext = result?.data?.repositoryOwner?.repositories.pageInfo.hasNextPage
            if(hasNext == true) {
                if let cursor = result?.data?.repositoryOwner?.repositories.pageInfo.endCursor {
                    self?.getReposContinued(owner: owner, cursor: cursor)
                }
                else {
                    Alerter.hidePreloader()
                    self?.sortRepos()
                    NotificationCenter.default.post(name: .LOADING_COMPLETE, object: nil)
                }
            }
            else {
                Alerter.hidePreloader()
                self?.sortRepos()
                NotificationCenter.default.post(name: .LOADING_COMPLETE, object: nil)
            }
        }
    }
    
    /**
     Sort and prep the repository data
     */
    func sortRepos() {
        
        //Sort by stargazers
        for (_, repArr) in self.tempRepos {
            _ = repArr.sorted(by: {$0.stargazers > $1.stargazers })
        }
        
        //Sort by number of repos
        let sortedDict = self.tempRepos.sorted(by: {$0.value.count > $1.value.count})
        
        let repoEntries:RepoEntryList = RepoEntryList()
        repoEntries.username = self.currentOwner
        
        //Create an array we can actually work with
        self.repositories.value.removeAll()
        for(lang, rep) in sortedDict {
            let entry = RepoEntry()
            entry.language = lang
            entry.repos.append(objectsIn: rep)
            repoEntries.repoEntries.append(entry)
            self.repositories.value.append(entry)
        }
        
        
        let realm = try! Realm()
        let reps = realm.objects(RepoEntryList.self).filter({$0.username == self.currentOwner})
        if(reps.count > 0) {
            let entries = reps.first
            
            try! realm.write {
                entries!.repoEntries = repoEntries.repoEntries
            }
        }
        else {
            try! realm.write {
                realm.add(repoEntries)
            }
        }
        
    }
    
    /**
     Get a single name suggestion
     */
    func getUsernameSuggestion(substring:String, complete:@escaping (String?) -> Void) {
        //Had to be created this way according to Github
        let qString = "type:user \(substring) in:login"
        
        self.apollo?.fetch(query:  UserNameQuery(queryString: qString)) { [weak self] result, error
            in
            
            if(error != nil)
            {
                
                Alerter.hidePreloader()
                self?.tokenError()
                return
            }
            
            let _ = self
            self?.tokenSuccess()
            
            var theNames = [String]()
            if let items = result?.data?.search.edges {
                for var x in  items{
                    if let aName = x?.node?.asUser?.login {
                        theNames.append(aName)
                    }
                }
            }
            
            
            let name = result?.data?.search.edges?.first??.node?.asUser?.login
            complete(name)
        }
    }
    
    /**
     Get multiple name suggestions (first 100)
     */
    func getUsernameSuggestions(substring:String, complete:@escaping ([String]) -> Void) {
        //Had to be created this way according to Github
        let qString = "type:user \(substring) in:login"
        
        self.apollo?.fetch(query:  UserNameQuery(queryString: qString)) { [weak self] result, error
            in
            
            if(error != nil)
            {
                Alerter.hidePreloader()
                
                let err = error! as! GraphQLHTTPResponseError
                //print(err.errorDescription)
                //print(err.response.statusCode)
                if(err.response.statusCode == 401) {
                    self?.tokenError()
                }
                return
            }
            
            let _ = self
            self?.tokenSuccess()
            
            var theNames = [String]()
            if let items = result?.data?.search.edges {
                for var x in  items{
                    if let aName = x?.node?.asUser?.login {
                        theNames.append(aName)
                    }
                }
            }
            
            complete(theNames)
        }
    }
    
    private func tokenError() {
        if(self.tokenIsValid == false){
            return
        }
        
        self.setTokenIsValid(val: false)
        Alerter.alert(title: "Error", msg: "Could not fetch github data.  Please make sure your token is set correctly, or try again later")
    }
    
    private func tokenSuccess() {
        self.setTokenIsValid(val: true)
    }
    
    
    
    /*******/
    /**
     Get multiple name suggestions (first 100)
     */
    func checkToken(complete:@escaping (Bool) -> Void) {
        //Had to be created this way according to Github
        let qString = "type:user facebook in:login"
        
        self.apollo?.fetch(query:  UserNameQuery(queryString: qString)) { [weak self] result, error
            in
            print(result)
            print(error)
            if(error != nil)
            {
                complete(false)
                return
            }
            
            complete(true)
        }
    }
    
}
