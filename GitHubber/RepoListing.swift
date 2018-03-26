//
//  RepoListing.swift
//  GitHubber
//
//  Created by user on 3/26/18.
//  Copyright © 2018 Shalom Friss. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class RepoListing:UIViewController {
    
    @IBOutlet weak var repoTable:UITableView?
    let repos = Observable.just(DataManager.instance.repos)
    
    private func setupTableView() {
        //repos.bind(to: repoTable.rx.items(cellIdentifier: ))
    }
}



