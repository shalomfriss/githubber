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
    
    private static var _instance:DataManager = DataManager(123) //the instance
    private var apollo: ApolloClient?   //The Apollo client
    private let disposeBag = DisposeBag()   //RXSwift dispose bag
    private var _repos:BehaviorRelay<[(key:String, value:[RepoVO])]> = BehaviorRelay(value: []) //Repo container
    public var repos:BehaviorRelay<[(key:String, value:[RepoVO])]> {
        get {
            return self._repos
        }
    }
    
    //Singleton method
    public static var instance:DataManager {
        get {
            return _instance
        }
    }
    
    
    init() {
        assertionFailure("Cannot instantiate DataManager directly use DataManager.instance")
    }
    
    init(_ check:Int) {
        if(check != 123) {
            assertionFailure("Cannot instantiate DataManager directly use DataManager.instance")
        }
        self.setupReposReaction()
        
        self.apollo = {
            let configuration = URLSessionConfiguration.default
            configuration.httpAdditionalHeaders = ["Authorization": "Bearer \(Config.GITHUB_TOKEN)"]
            let url = URL(string: Config.GITHUB_URL)!
            return ApolloClient(networkTransport: HTTPNetworkTransport(url: url, configuration: configuration))
        }()
    }
    
    func setupReposReaction() {
        self._repos.asObservable().subscribe(onNext: {
            rps in
            //print("ADDING ******")
            //print(rps)
        }).disposed(by: self.disposeBag)
    }
    
    func getRepos(owner:String) {
        
        var res:[String:[RepoVO]] = [:]
        
        self.apollo?.fetch(query: ReposQuery(user: owner)){ [weak self] result, error
            in
            
            let _ = self
            result?.data?.repositoryOwner?.repositories.edges?.forEach { edge in
                guard let repo = edge?.node else { return }
                print("------------")
                
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
                
                print(repovo.name)
                print(repovo.description)
                print(repovo.primaryLanguage)
                print(repovo.forks)
                print(repovo.stargazers)
                print(repovo.updatedAt)
                print(repovo.url)
                
                //Github has their own language detection so no need to massage the language name
                if(res[repovo.primaryLanguage] == nil) {
                    res[repovo.primaryLanguage] = [RepoVO]()
                }
                
                res[repovo.primaryLanguage]?.append(repovo)
            }
            
            //Sort by stargazers
            for (_, repArr) in res {
                _ = repArr.sorted(by: {$0.stargazers > $1.stargazers })
            }
            
            //Sort by number of repos
            let sortedDict = res.sorted(by: {$0.value.count > $1.value.count})
            self?._repos.accept(sortedDict)
            guard let temp = self?._repos.value else {
                return
            }
            
            for(lang, rep) in temp {
                print("\(lang) - \(rep.count)")
            }
        }
        
        
    }
}
