//
//  CellController.swift
//  Reddit-Showcase
//
//  Created by Gustavo on 11/06/21.
//

import UIKit

protocol CellControllerDelegate {
    func didRequestImage(with url: URL)
    func didCancelImageRequest()
}

class CellController: Hashable, ImagePresenterView {
    private let delegate: CellControllerDelegate
    private var cell: RedditFeedCell?
    private let thumbnailUrl: URL?
    
    public init(thumbnailUrl: URL?, delegate: CellControllerDelegate) {
        self.delegate = delegate
        self.thumbnailUrl = thumbnailUrl
    }
    
    func view(in tableView: UITableView, at indexpath: IndexPath) -> UITableViewCell {
        cell = tableView.dequeueReusableCell(at: indexpath)
        preload()
        return cell!
    }
    
    public func display(_ viewModel: FeedImageViewModel<UIImage>) {
        cell?.tiltleLabel?.text = viewModel.title
        cell?.authorLabel?.text = viewModel.author
        cell?.tiltleLabel?.text = viewModel.title
        cell?.tiltleLabel?.text = viewModel.title
        cell?.tiltleLabel?.text = viewModel.title
        cell?.tiltleLabel?.text = viewModel.title
    }
    
    func preload() {
        guard let url = thumbnailUrl else { return }
        delegate.didRequestImage(with: url)
    }
    
    func cancelLoad() {
        cell = nil
        delegate.didCancelImageRequest()
    }
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(cell)
    }
    
    public static func == (lhs: CellController, rhs: CellController) -> Bool {
        return lhs.cell == rhs.cell
    }
}

private extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>(at index: IndexPath) -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: identifier, for: index) as! T
    }
}
