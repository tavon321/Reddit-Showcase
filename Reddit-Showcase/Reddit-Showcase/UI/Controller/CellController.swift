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
    func didRequestRemoveCell(at index: IndexPath)
    func didRequestExpandImage(with url: URL)
}

final class CellController: Hashable, ImagePresenterView {
    private let delegate: CellControllerDelegate
    private var cell: RedditFeedCell?
    private let thumbnailUrl: URL?
    private var indexpath: IndexPath = IndexPath()
    private var isVisited: Bool = false
    
    public init(thumbnailUrl: URL?, delegate: CellControllerDelegate) {
        self.delegate = delegate
        self.thumbnailUrl = thumbnailUrl
    }
    
    func view(in tableView: UITableView, at indexpath: IndexPath) -> UITableViewCell {
        self.cell = tableView.dequeueReusableCell(at: indexpath)
        self.indexpath = indexpath
        self.preload()
        return self.cell!
    }
    
    public func display(_ viewModel: FeedImageViewModel<UIImage>) {
        cell?.tiltleLabel?.text = viewModel.title
        cell?.thumbnailImageView?.image = viewModel.thumbnail ?? cell?.thumbnailImageView?.image
        cell?.commentLabel?.text = viewModel.numberOfComments
        cell?.authorAndTimeLabel?.text = viewModel.timeAndAuthor
        cell?.isReadedContainer.isReaded = isVisited
        cell?.saveImage.isHidden = viewModel.imageURL == nil
        
        cell?.onImageTap = { [weak self] in
            guard let self = self, let url = viewModel.imageURL else { return }
            self.delegate.didRequestExpandImage(with: url)
        }
        
        cell?.onRemoveTap = { [weak self] in
            guard let self = self else { return }
            self.delegate.didRequestRemoveCell(at: self.indexpath)
        }
        
        cell?.onSaveTap = { [weak self] in
            guard let self = self, let url = viewModel.imageURL else { return }
            self.delegate.didRequestSaveImage(with: url)
        }
    }
    
    func selectCell() {
        isVisited = !isVisited
        cell?.isReadedContainer.isReaded = isVisited
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
        cell?.saveImage.finish(error: !didFinishSavingDataSuccessfully)
    }
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(cell)
    }
    
    public static func == (lhs: CellController, rhs: CellController) -> Bool {
        return lhs.cell == rhs.cell
    }
}
