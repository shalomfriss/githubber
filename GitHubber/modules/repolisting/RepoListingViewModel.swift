//
//  RepoListingViewModel.swift
//  GitHubber
//
//  Created by user on 11/6/18.
//  Copyright © 2018 Shalom Friss. All rights reserved.
//

import Foundation
import RxSwift

class RepoListingViewModel {
    private var model: RepoListingModel
    
    public var reps:Observable<[RepoEntry]> {
        return model.reps
    }
    
    public init(model: RepoListingModel) {
        self.model = model
        self.model.reps = DataManager.instance.repositories.asObservable()
    }
    
}
