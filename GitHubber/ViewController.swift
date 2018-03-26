//
//  ViewController.swift
//  GitHubber
//
//  Created by user on 3/21/18.
//  Copyright © 2018 Shalom Friss. All rights reserved.
//

import UIKit
import Apollo

class ViewController: UIViewController {
    
    var GITHUB_TOKEN:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let value = ProcessInfo.processInfo.environment["github_token"] {
            print("Github - \(value)")
        }
        else {
            print("No env token")
        }
        
        let apollo: ApolloClient = {
            let configuration = URLSessionConfiguration.default
            configuration.httpAdditionalHeaders = ["Authorization": "Bearer \(GITHUB_TOKEN)"]
            let url = URL(string: "https://api.github.com/graphql")!
            return ApolloClient(networkTransport: HTTPNetworkTransport(url: url, configuration: configuration))
        }()
        
        
        let queryString = "GraphQL"
        apollo.fetch(query: SearchRepositoriesQuery(query: queryString, count: 10)) { [weak self] result, error in
            
            result?.data?.search.edges?.forEach { edge in
                guard let repository = edge?.node?.asRepository else { return }
                print("-----------------")
                print("Name: \(repository.name)")
                print("Name: \(repository.description!)")
                print("Lang: \(repository.primaryLanguage!.snapshot.first!.value!)")
                print("Path: \(repository.url)")
                print("Forks: \(repository.forks.snapshot.first!.value!)")
                //print("Owner: \(repository.owner.path)")
                print("Stars: \(repository.stargazers.totalCount)")
                print("Updated: \(repository.updatedAt)")
                
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

