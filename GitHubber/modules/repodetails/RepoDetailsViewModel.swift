//
//  RepoDetailsViewModel.swift
//  GitHubber
//
//  Created by user on 11/7/18.
//  Copyright © 2018 Shalom Friss. All rights reserved.
//

import Foundation
import RxSwift

class RepoDetailsViewModel {
    
    public let model:RepoDetailsModel = RepoDetailsModel()
    
    public var repoDetails:Observable<[RepoVO]> {
        return model.repoDetails
    }
    
    init() {
        model.repoDetails = DataManager.instance.languageRepos.asObservable()
    }
    
}
