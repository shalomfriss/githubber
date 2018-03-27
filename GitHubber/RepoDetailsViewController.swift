//
//  RepoDetails.swift
//  GitHubber
//
//  Created by user on 3/26/18.
//  Copyright © 2018 Shalom Friss. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class RepoDetailsViewController:UIViewController {
    
    @IBOutlet weak var reposTable:UITableView?
    
    let repoDetails = DataManager.instance.languageRepos.asObservable()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.setupTableView()
        self.reposTable?.rx.setDelegate(self).disposed(by: self.disposeBag)
    }
    
    private func setupTableView() {
        
        guard self.reposTable != nil else { return }
        
        self.repoDetails.bind(to: self.reposTable!.rx.items(cellIdentifier: RepoDetailsTableCell.Identifier, cellType: RepoDetailsTableCell.self))
        {
            (row: Int, element: RepoVO, cell: RepoDetailsTableCell) in
            
            
            cell.config(name: element.name, desc: element.description, stars: element.stargazers,
                        forks: element.forks, updated: element.updatedAt)
        }.disposed(by: self.disposeBag)
        
    }
    
}

extension RepoDetailsViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 115
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath)
    {
        let itemCount = DataManager.instance.languageRepos.value.count - 1
        let color = (CGFloat(indexPath.row) / CGFloat(itemCount)) * 0.5
        
        cell.backgroundColor = UIColor(red: 0.5, green: 0.5 + color, blue: 1, alpha: 0.5)
       
    }
}

