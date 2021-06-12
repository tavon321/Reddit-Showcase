//
//  ImagePresenter.swift
//  Reddit-Showcase
//
//  Created by Gustavo on 10/06/21.
//

import Foundation

public protocol ImagePresenterView: AnyObject {
    associatedtype Image
    func display(_ model: FeedImageViewModel<Image>)
    func diplay(isSavingData: Bool)
    func diplay(didFinishSavingDataSuccessfully: Bool)
}

public class ImagePresenter<View: ImagePresenterView, Image> where View.Image == Image {
    private weak var view: View?
    private let imageTransformer: (Data) -> Image?
    
    public init(view: View, imageTransformer: @escaping (Data) -> Image?) {
        self.view = view
        self.imageTransformer = imageTransformer
    }
    
    public func didStartLoadingImageData(for model: FeedViewModel) {
        view?.display(.init(title: model.title,
                           author: model.author,
                           entryDate: model.entryDate,
                           numberOfComments: model.numberOfComments,
                           imageURL: model.imageURL,
                           thumbnail: nil,
                           isLoading: true))
    }
    
    public func didFinishLoadingImageData(with data: Data, for model: FeedViewModel) {
        view?.display(.init(title: model.title,
                           author: model.author,
                           entryDate: model.entryDate,
                           numberOfComments: model.numberOfComments,
                           imageURL: model.imageURL,
                           thumbnail: imageTransformer(data),
                           isLoading: false))
    }
    
    public func didFinishLoadingImageData(with error: Error, for model: FeedViewModel) {
        view?.display(.init(title: model.title,
                           author: model.author,
                           entryDate: model.entryDate,
                           numberOfComments: model.numberOfComments,
                           imageURL: model.imageURL,
                           thumbnail: nil,
                           isLoading: false))
    }
    
    public func didStartSavingData() {
        view?.diplay(isSavingData: true)
    }
    
    public func didFinishSavingData(with error: Error) {
        view?.diplay(isSavingData: false)
        view?.diplay(didFinishSavingDataSuccessfully: true)
    }
    
    public func didFinishSavingData() {
        view?.diplay(isSavingData: false)
        view?.diplay(didFinishSavingDataSuccessfully: true)
    }
}
