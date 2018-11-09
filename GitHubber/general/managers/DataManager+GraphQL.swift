//
//  DataManager+GraphQL.swift
//  GitHubber
//
//  Created by user on 11/8/18.
//  Copyright © 2018 Shalom Friss. All rights reserved.
//

import Foundation
import Apollo
import RxSwift
import RxCocoa
import RealmSwift

extension DataManager {
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
     Get the repos of the mentioned owner
     @param owner:String - A string describing the owner
     */
    func getRepos(owner:String) {
        
        let connected = DataManager.isConnectedToNetwork()
        if(connected == false) {
            self.restoreFromCache(owner: owner)
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
    
}
