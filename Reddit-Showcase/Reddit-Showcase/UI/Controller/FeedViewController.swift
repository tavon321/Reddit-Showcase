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

class FeedViewController: UITableViewController, RedditFeedView, UITableViewDataSourcePrefetching {
    @IBOutlet private(set) public var errorView: ErrorView?
    private var dataSource: FeedViewControllerDataSource!
    
    public var delegate: FeedViewControllerDelegate?
    
    private var currentPage: String = ""
    private var isFetchInProgress: Bool = false
    
    private var loadingControllers = [IndexPath: CellController]()
    private var tableModel = [CellController]() {
        didSet { dataSource?.applySnapshot(for: tableModel) }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configTable()
        delegate?.didRequestFeedRefresh(page: "")
        configureDismissAllButton()
    }
    
    private func configureDismissAllButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Dimiss All",
                                                            style: .plain,
                                                            target: self, action: #selector(dismissAllTapped))
    }
    
    private func configTable() {
        tableView.dataSource = dataSource
        tableView.prefetchDataSource = self
        dataSource = FeedViewControllerDataSource(tableView: tableView) { [weak self] indexPath in
            self?.cellController(forRowAt: indexPath)
        }
    }
    
    @objc private func dismissAllTapped() {
        removeOldCells()
    }
    
    @IBAction private func refresh() {
        removeOldCells()
        delegate?.didRequestFeedRefresh(page: "")
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        tableView.sizeTableHeaderToFit()
    }
    
    func display(_ controllers: [CellController], page: String) {
        currentPage = page
        loadingControllers = [:]
        tableModel.append(contentsOf: controllers)
    }
    
    func display(isLoading: Bool) {
        isFetchInProgress = isLoading
        refreshControl?.update(isRefreshing: isLoading)
    }
    
    func display(_ viewModel: FeedErrorViewModel) {
        errorView?.message = viewModel.message
    }
    
    private func removeOldCells() {
        currentPage = ""
        tableModel.removeAll()
        loadingControllers = [:]
    }
    
    private func fecthMoreCells() {
        guard currentPage != "", !isFetchInProgress else { return }
        delegate?.didRequestFeedRefresh(page: currentPage)
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
        loadNextPageIfNeeded(for: indexPaths)
    }
    
    public override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cancelCellControllerLoad(forRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach(cancelCellControllerLoad)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableModel[indexPath.row].selectCell()
    }
    
    private func loadNextPageIfNeeded(for indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            fecthMoreCells()
        }
    }
    
    private func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= tableModel.count - 1
    }
    
    private func cancelCellControllerLoad(forRowAt indexPath: IndexPath) {
        loadingControllers[indexPath]?.cancelLoad()
        loadingControllers[indexPath] = nil
    }
}

extension FeedViewController: CellDestructionView {
    func removeCell(at index: IndexPath) {
        tableModel.remove(at: index.row)
    }
}
