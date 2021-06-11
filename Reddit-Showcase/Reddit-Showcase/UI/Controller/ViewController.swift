//
//  ViewController.swift
//  Reddit-Showcase
//
//  Created by Gustavo on 8/06/21.
//

import UIKit

public protocol FeedViewControllerDelegate {
    func didRequestFeedRefresh(page: String)
}

class ViewController: UITableViewController {
}
