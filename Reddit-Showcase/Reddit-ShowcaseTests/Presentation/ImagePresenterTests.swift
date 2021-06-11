//
//  ImagePresenterTests.swift
//  Reddit-ShowcaseTests
//
//  Created by Gustavo on 10/06/21.
//

import XCTest
import Reddit_Showcase

public struct FeedImageViewModel<Image> {
    public let title: String
    public let author: String
    public let elapsedInterval: String
    public let numberOfComments: String
    public let imageURL: URL?
    public let thumbnail: Image?
    public let isLoading: Bool
}

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
    
    func didStartLoadingImageData(for model: FeedViewModel) {
        view.display(.init(title: model.title,
                           author: model.author,
                           elapsedInterval: model.elapsedInterval,
                           numberOfComments: model.numberOfComments,
                           imageURL: model.imageURL,
                           thumbnail: nil,
                           isLoading: true))
    }
    
    func didFinishLoadingImageData(with data: Data, for model: FeedViewModel) {
        view.display(.init(title: model.title,
                           author: model.author,
                           elapsedInterval: model.elapsedInterval,
                           numberOfComments: model.numberOfComments,
                           imageURL: model.imageURL,
                           thumbnail: imageTransformer(data),
                           isLoading: false))
    }
}

class ImagePresenterTests: XCTestCase {
    func test_init_doesNotMessageView() {
        let (_, view) = makeSUT()
        
        XCTAssertEqual(view.messages.count, 0)
    }
    
    func test_didStartLoadingImageData_displaysLoadingImage() {
        let (sut, view) = makeSUT()
        let model = feedModel
        
        sut.didStartLoadingImageData(for: model)
        
        let message = view.messages.first
        XCTAssertEqual(view.messages.count, 1)
        XCTAssertEqual(message?.title, model.title)
        XCTAssertEqual(message?.author, model.author)
        XCTAssertEqual(message?.elapsedInterval, model.elapsedInterval)
        XCTAssertEqual(message?.numberOfComments, model.numberOfComments)
        XCTAssertEqual(message?.imageURL, model.imageURL)
        XCTAssertEqual(message?.isLoading, true)
    }
    
    func test_didFinishLaodingImageFata_displayViewModelWithImage() {
        let transformedData = AnyImage()
        let (sut, view) = makeSUT(imageTransformer: { _ in transformedData })
        let model = feedModel
        
        sut.didFinishLoadingImageData(with: Data(), for: model)
        
        let message = view.messages.first
        XCTAssertEqual(view.messages.count, 1)
        XCTAssertEqual(message?.title, model.title)
        XCTAssertEqual(message?.author, model.author)
        XCTAssertEqual(message?.elapsedInterval, model.elapsedInterval)
        XCTAssertEqual(message?.numberOfComments, model.numberOfComments)
        XCTAssertEqual(message?.imageURL, model.imageURL)
        XCTAssertEqual(message?.isLoading, false)
        XCTAssertEqual(message?.thumbnail, transformedData)
    }
    
    // MARK: Helpers
    private var feedModel = FeedViewModel(item: sampleFeed)
    private struct AnyImage: Equatable {}
    
    private func makeSUT(imageTransformer: @escaping (Data) -> AnyImage? = { _ in nil },
                         file: StaticString = #file,
                         line: UInt = #line)
    -> (sut: ImagePresenter<ViewSpy, AnyImage>, view: ViewSpy) {
        let view = ViewSpy()
        let sut = ImagePresenter(view: view, imageTransformer: imageTransformer)
        
        trackForMemoryLeaks(view, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, view)
    }
    
    private class ViewSpy: ImagePresenterView {
        private(set) var messages = [FeedImageViewModel<AnyImage>]()
        
        func display(_ model: FeedImageViewModel<AnyImage>) {
            messages.append(model)
        }
    }
}
