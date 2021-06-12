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
    func didRequestSaveImage(with url: URL)
}

class CellController: Hashable, ImagePresenterView {
    private let delegate: CellControllerDelegate
    private var cell: RedditFeedCell?
    private let thumbnailUrl: URL?
    private let model: FeedViewModel
    private var isVisited: Bool = false
    
    public init(thumbnailUrl: URL?, model: FeedViewModel, delegate: CellControllerDelegate) {
        self.delegate = delegate
        self.thumbnailUrl = thumbnailUrl
        self.model = model
    }
    
    func view(in tableView: UITableView, at indexpath: IndexPath) -> UITableViewCell {
        cell = tableView.dequeueReusableCell(at: indexpath)
        preload()
        return cell!
    }
    
    public func display(_ viewModel: FeedImageViewModel<UIImage>) {
        cell?.tiltleLabel?.text = viewModel.title
        cell?.thumbnailImageView?.image = viewModel.thumbnail ?? cell?.thumbnailImageView?.image
        cell?.commentLabel?.text = viewModel.numberOfComments
        cell?.authorAndTimeLabel?.text = viewModel.timeAndAuthor
        cell?.isReadedContainer.isHidden = !isVisited
        cell?.saveImage.isHidden = viewModel.imageURL == nil
        
        cell?.onSaveTap = { [weak self] in
            guard let self = self, let url = viewModel.imageURL else { return }
            self.delegate.didRequestSaveImage(with: url)
        }
    }
    
    func selectCell() {
        isVisited = !isVisited
        cell?.isReadedContainer.isHidden = !isVisited
    }
    
    func preload() {
        guard let url = thumbnailUrl else { return }
        delegate.didRequestImage(with: url)
    }
    
    func cancelLoad() {
        cell = nil
        delegate.didCancelImageRequest()
    }
    
    func diplay(isSavingData: Bool) {
        cell?.saveImage.isLoading = isSavingData
    }
    
    func diplay(didFinishSavingDataSuccessfully: Bool) {
        cell?.saveImage.finish(error: didFinishSavingDataSuccessfully)
    }
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(model)
    }
    
    public static func == (lhs: CellController, rhs: CellController) -> Bool {
        return lhs.model == rhs.model
    }
}

private extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>(at index: IndexPath) -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: identifier, for: index) as! T
    }
}
