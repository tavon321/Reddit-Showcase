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
    
    func display(isLoading: Bool) {
        
    }
    
    func display(_ viewModel: FeedErrorViewModel) {
        
    }
    
    func display(_ viewModel: FeedListViewModel) {
        
    }
}
