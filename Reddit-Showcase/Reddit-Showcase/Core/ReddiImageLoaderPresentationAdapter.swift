//
//  ReddiImageLoaderPresentationAdapter.swift
//  Reddit-Showcase
//
//  Created by Gustavo on 11/06/21.
//

import UIKit

class ReddiImageLoaderPresentationAdapter<View: ImagePresenterView, Image>: CellControllerDelegate where View.Image == Image {
   
    
    
    private let model: FeedViewModel
    private let imageLoader: ImageDataLoader
    private var cache = NSCache<NSURL, NSData>()
    private var cancellable: HTTPClientTask?
    
    var presenter: ImagePresenter<View, Image>?
    
    init(model: FeedViewModel, imageLoader: ImageDataLoader) {
        self.model = model
        self.imageLoader = imageLoader
    }
    
    func didRequestImage(with url: URL) {
        presenter?.didStartLoadingImageData(for: model)
        
        let model = self.model
        
        if let cachedData = cache.object(forKey: url.nsURL) as Data? {
            presenter?.didFinishLoadingImageData(with: cachedData, for: model)
        } else {
            cancellable = imageLoader.loadImageData(from: url) { [weak self] result in
                switch result {
                case .success(let data):
                    self?.cache.setObject(data as NSData, forKey: url.nsURL)
                    self?.presenter?.didFinishLoadingImageData(with: data, for: model)
                case .failure(let error):
                    self?.presenter?.didFinishLoadingImageData(with: error, for: model)
                }
            }
        }
    }
    
    func didRequestSaveImage(with url: URL) {
    }
    
    func didCancelImageRequest() {
        cancellable?.cancel()
    }
}
