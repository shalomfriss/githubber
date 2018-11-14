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

class RepoListingViewController:UIViewController {
    
    
    @IBOutlet weak var repoCollection: UICollectionView!
    
    //let reps = DataManager.instance.repositories.asObservable()
    let disposeBag = DisposeBag()
    
    var viewModel:RepoListingViewModel = RepoListingViewModel(model: RepoListingModel())
    
    //MARK:- UIViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Repo listing"
        
        self.setupTableView()
        self.setupTapHandler()
    }
    
    
    //MARK:- Setup methods
    
    
    /// Setup the table view using rx swift. This is a more succinct way of expressing how the table will function
    private func setupTableView() {
        
        guard self.repoCollection != nil else { return }
        
        
        viewModel.reps.bind(to: self.repoCollection!.rx.items(cellIdentifier: RepoCollectionCell.Identifier, cellType: RepoCollectionCell.self)) {
            (row: Int, element: RepoEntry, cell: RepoCollectionCell) in
            
            cell.config(name: element.language, cnt: element.count, data: element)
        }.disposed(by: self.disposeBag)
        
    }
    
   
    
    /// Setup the tap handlers of the table
    private func setupTapHandler() {
        guard self.repoCollection != nil else { return }
        
        self.repoCollection!
            .rx
            .modelSelected(RepoEntry.self)
            .subscribe(onNext: {
                repoEntry in
                
                DataManager.instance.languageRepos.value.removeAll()
                DataManager.instance.languageRepos.value.append(contentsOf: repoEntry.repos)
                
                if let selectedRowIndexPath = self.repoCollection?.indexPathsForSelectedItems {
                    self.repoCollection?.deselectItem(at: selectedRowIndexPath[0], animated: true)
                }
                
                self.performSegue(withIdentifier: "repoDetails", sender: nil)
            })
            .disposed(by: self.disposeBag)
    }
    
}



