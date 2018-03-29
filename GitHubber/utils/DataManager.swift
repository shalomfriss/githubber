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
    */
    func getRepoCount(owner:String) {
        
        Alerter.showPreloader()
        self.apollo?.fetch(query: RepoCountQuery(user: owner)){ [weak self] result, error
            in
            
            if(error != nil)
            {
                Alerter.alert(title: "Error", msg: "Could not fetch github data.  Please make sure your token is set correctly, or try again later")
                return
            }
            
            let _ = self
            let count = result?.data?.repositoryOwner?.repositories.totalCount ?? 0
            self?.totalRepos = count
            Alerter.hidePreloader()
        }
    }
    
    
    /**
        Get the repos of the mentioned owner
        @param owner:String - A string describing the owner
    */
    func getRepos(owner:String) {
        
        print("Get repos")
        Alerter.showPreloader()
       self.apollo?.fetch(query:  ReposQuery(user: owner)) { [weak self] result, error
            in
        
            if(error != nil)
            {
                Alerter.hidePreloader()
                Alerter.alert(title: "Error", msg: "Could not fetch github data.  Please make sure your token is set correctly, or try again later")
                return
            }
            
        
            let _ = self
            result?.data?.repositoryOwner?.repositories.edges?.forEach { edge in
                guard let repo = edge?.node else { return }
                
                //Create a value object for the repo, this gives us an easy way to deal with a repo
                //Representation and also is self-documenting
                let repovo = RepoVO()
                repovo.name = repo.name
                repovo.description = repo.description ?? ""
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
                Alerter.alert(title: "Error", msg: "Could not fetch github data.  Please make sure your token is set correctly, or try again later")
                return
            }
            
            let _ = self
            result?.data?.repositoryOwner?.repositories.edges?.forEach { edge in
                guard let repo = edge?.node else { return }
                
                //Create a value object for the repo, this gives us an easy way to deal with a repo
                //Representation and also is self-documenting
                let repovo = RepoVO()
                repovo.name = repo.name
                repovo.description = repo.description ?? ""
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
        
        //Create an array we can actually work with
        self.repositories.value.removeAll()
        for(lang, rep) in sortedDict {
            let entry = RepoEntry()
            entry.language = lang
            entry.repos = rep
            self.repositories.value.append(entry)
        }
    }
    
}
