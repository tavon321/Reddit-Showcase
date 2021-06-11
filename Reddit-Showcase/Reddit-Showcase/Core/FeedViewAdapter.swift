//
//  FeedViewAdapter.swift
//  Reddit-Showcase
//
//  Created by Gustavo on 11/06/21.
//

import UIKit

final class FeedViewAdapter: RedditListView {
    private weak var controller: FeedViewController?
    private let imageLoader: RemoteImageDataLoader
    
    init(controller: FeedViewController, imageLoader: RemoteImageDataLoader) {
        self.controller = controller
        self.imageLoader = imageLoader
    }
    
    func display(_ viewModel: FeedListViewModel) {
        controller?.display(viewModel.feedViewModels.map({ model in
            let adapter = ReddiImageLoaderPresentationAdapter<CellController, UIImage>(model: model,
                                                                                       imageLoader: imageLoader)
            let controller = CellController(thumbnailUrl: model.thumbnail, delegate: adapter)
            adapter.presenter = ImagePresenter(view: controller, imageTransformer: UIImage.init)
            
            return controller
        }), page: viewModel.pagination ?? "")
    }
}
