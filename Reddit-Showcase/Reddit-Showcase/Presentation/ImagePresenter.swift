//
//  ImagePresenter.swift
//  Reddit-Showcase
//
//  Created by Gustavo on 10/06/21.
//

import Foundation

public protocol ImagePresenterView {
    associatedtype Image
    func display(_ model: FeedImageViewModel<Image>)
}

public class ImagePresenter<View: ImagePresenterView, Image> where View.Image == Image {
    private let view: View
    private let imageTransformer: (Data) -> Image?
    
    public init(view: View, imageTransformer: @escaping (Data) -> Image?) {
        self.view = view
        self.imageTransformer = imageTransformer
    }
    
    public func didStartLoadingImageData(for model: FeedViewModel) {
        view.display(.init(title: model.title,
                           author: model.author,
                           entryDate: model.entryDate,
                           numberOfComments: model.numberOfComments,
                           imageURL: model.imageURL,
                           thumbnail: nil,
                           isLoading: true))
    }
    
    public func didFinishLoadingImageData(with data: Data, for model: FeedViewModel) {
        view.display(.init(title: model.title,
                           author: model.author,
                           entryDate: model.entryDate,
                           numberOfComments: model.numberOfComments,
                           imageURL: model.imageURL,
                           thumbnail: imageTransformer(data),
                           isLoading: false))
    }
    
    public func didFinishLoadingImageData(with error: Error, for model: FeedViewModel) {
        view.display(.init(title: model.title,
                           author: model.author,
                           entryDate: model.entryDate,
                           numberOfComments: model.numberOfComments,
                           imageURL: model.imageURL,
                           thumbnail: nil,
                           isLoading: false))
    }
}
