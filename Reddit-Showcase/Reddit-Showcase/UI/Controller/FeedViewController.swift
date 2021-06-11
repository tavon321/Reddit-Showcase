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
    
    public var delegate: FeedViewControllerDelegate?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        refresh()
    }
    
    @IBAction private func refresh() {
        delegate?.didRequestFeedRefresh(page: "")
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        tableView.sizeTableHeaderToFit()
    }
    
    func display(isLoading: Bool) {
        
    }
    
    func display(_ viewModel: FeedErrorViewModel) {
        
    }
    
    func display(_ viewModel: FeedListViewModel) {
        
    }
}

extension UITableView {
    func sizeTableHeaderToFit() {
        guard let header = tableHeaderView else { return }
        
        let size = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        
        let needsFrameUpdate = header.frame.height != size.height
        if needsFrameUpdate {
            header.frame.size.height = size.height
            tableHeaderView = header
        }
    }
}
