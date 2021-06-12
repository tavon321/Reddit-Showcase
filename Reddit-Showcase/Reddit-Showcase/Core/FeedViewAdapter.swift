//
//  FeedViewAdapter.swift
//  Reddit-Showcase
//
//  Created by Gustavo on 11/06/21.
//

import UIKit

final class FeedViewAdapter: RedditListView {
    private weak var controller: FeedViewController?
    private let imageLoader: ImageDataLoader
    private let imageSaver: ImageSaver
    
    init(controller: FeedViewController,
         imageLoader: ImageDataLoader,
         imageSaver: ImageSaver) {
        self.controller = controller
        self.imageLoader = imageLoader
        self.imageSaver = imageSaver
    }
    
    func display(_ viewModel: FeedListViewModel) {
        controller?.display(viewModel.feedViewModels.map({ model in
            let adapter = ReddiImageLoaderPresentationAdapter<CellController, UIImage>(model: model,
                                                                                       imageLoader: imageLoader,
                                                                                       imageSaver: imageSaver)
            let cellController = CellController(thumbnailUrl: model.thumbnail, delegate: adapter)
            adapter.presenter = ImagePresenter(view: cellController,
                                               cellDestructionView: self.controller,
                                               expandedImagePresenterView: self.controller,
                                               imageTransformer: UIImage.init)
            
            return cellController
        }), page: viewModel.pagination ?? "")
    }
}
