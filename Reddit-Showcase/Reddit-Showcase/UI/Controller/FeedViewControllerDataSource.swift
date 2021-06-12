//
//  FeedViewControllerDataSource.swift
//  Reddit-Showcase
//
//  Created by Gustavo on 11/06/21.
//

import UIKit

class FeedViewControllerDataSource: UITableViewDiffableDataSource<Int, CellController> {
    convenience init(tableView: UITableView,
                     cellController: @escaping (IndexPath) -> CellController?) {
        self.init(tableView: tableView) { (tableView, indexPath, controller) -> UITableViewCell? in
            return cellController(indexPath)?.view(in: tableView, at: indexPath)
        }
    }
    
    func applySnapshot(for profiles: [CellController]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, CellController>()
        
        snapshot.appendSections([0])
        snapshot.appendItems(profiles)
        
        apply(snapshot, animatingDifferences: true)
    }
}
