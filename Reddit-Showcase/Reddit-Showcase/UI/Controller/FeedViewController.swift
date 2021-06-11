//
//  FeedViewController.swift
//  Reddit-Showcase
//
//  Created by Gustavo on 8/06/21.
//

import UIKit

public protocol FeedViewControllerDelegate {
    func didRequestFeedRefresh(page: String)
}

class FeedViewController: UITableViewController, RedditFeedView {
    @IBOutlet private(set) public var errorView: ErrorView?
    private var dataSource: FeedViewControllerDataSource!
    
    public var delegate: FeedViewControllerDelegate?
    
    private var currentPage: String = ""
    
    private var loadingControllers = [IndexPath: CellController]()
    private var tableModel = [CellController]() {
        didSet { dataSource?.applySnapshot(for: tableModel) }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configTable()
        refresh()
    }
    
    private func configTable() {
        tableView.dataSource = dataSource
        dataSource = FeedViewControllerDataSource(tableView: tableView) { [weak self] indexPath in
            self?.cellController(forRowAt: indexPath)
        }
    }
    
    @IBAction private func refresh() {
        currentPage = ""
        delegate?.didRequestFeedRefresh(page: "")
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        tableView.sizeTableHeaderToFit()
    }
    
    func display(_ controllers: [CellController], page: String) {
        loadingControllers = [:]
        currentPage = page
        tableModel = controllers
    }
    
    func display(isLoading: Bool) {
        refreshControl?.update(isRefreshing: isLoading)
    }
    
    func display(_ viewModel: FeedErrorViewModel) {
        errorView?.message = viewModel.message
    }
    
    private func cellController(forRowAt indexPath: IndexPath) -> CellController {
        let controller = tableModel[indexPath.row]
        loadingControllers[indexPath] = controller
        return controller
    }
    
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            cellController(forRowAt: indexPath).preload()
        }
    }
    
    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach(cancelCellControllerLoad)
    }
    
    private func cancelCellControllerLoad(forRowAt indexPath: IndexPath) {
        loadingControllers[indexPath]?.cancelLoad()
        loadingControllers[indexPath] = nil
    }
}

extension UIRefreshControl {
    func update(isRefreshing: Bool) {
        isRefreshing ? beginRefreshing() : endRefreshing()
    }
}
