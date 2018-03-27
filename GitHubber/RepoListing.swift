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
    
    let reps = DataManager.instance.repositories.asObservable()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.setupTapHandler()
    }
    
    private func setupTableView() {
        
        guard self.repoTable != nil else { return }
        
        self.reps.bind(to: self.repoTable!.rx.items(cellIdentifier: RepoTableCell.Identifier, cellType: RepoTableCell.self)) {
            (row: Int, element: RepoEntry, cell: RepoTableCell) in
            
            cell.config(name: element.language, cnt: element.count, data: element)
        }.disposed(by: self.disposeBag)
        
    }
    
    private func setupTapHandler() {
        guard self.repoTable != nil else { return }
        
        self.repoTable!
            .rx
            .modelSelected(RepoEntry.self) //1
            .subscribe(onNext: { //2
                repoEntry in
                
                print(repoEntry.language)
                print(repoEntry.repos)
                if let selectedRowIndexPath = self.repoTable?.indexPathForSelectedRow {
                    self.repoTable?.deselectRow(at: selectedRowIndexPath, animated: true)
                } //4
            })
            .addDisposableTo(disposeBag) //5
    }
    
}



