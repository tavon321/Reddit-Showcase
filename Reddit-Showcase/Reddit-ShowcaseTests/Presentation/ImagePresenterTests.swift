//
//  ImagePresenterTests.swift
//  Reddit-ShowcaseTests
//
//  Created by Gustavo on 10/06/21.
//

import XCTest
import Reddit_Showcase

public struct FeedImageViewModel {
    public let title: String
    public let author: String
    public let elapsedInterval: String
    public let numberOfComments: String
    public let imageURL: URL?
    public let thumnail: UIImage?
    public let isLoading: Bool
}

public protocol ImagePresenterView {
    func display(_ model: FeedImageViewModel)
}

public class ImagePresenter {
    private let view: ImagePresenterView
    
    public init(view: ImagePresenterView) {
        self.view = view
    }
    
    func didStartLoadingImageData(for model: FeedViewModel) {
        view.display(.init(title: model.title,
                           author: model.author,
                           elapsedInterval: model.elapsedInterval,
                           numberOfComments: model.numberOfComments,
                           imageURL: model.imageURL,
                           thumnail: nil,
                           isLoading: true))
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
    
    // MARK: Helpers
    private var feedModel = FeedViewModel(item: sampleFeed)
    
    private func makeSUT(file: StaticString = #file,
                         line: UInt = #line) -> (sut: ImagePresenter, view: ImagePresenterViewSpy) {
        let view = ImagePresenterViewSpy()
        let sut = ImagePresenter(view: view)
        
        trackForMemoryLeaks(view, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, view)
    }
    
    private class ImagePresenterViewSpy: ImagePresenterView {
        private(set) var messages = [FeedImageViewModel]()
        
        func display(_ model: FeedImageViewModel) {
            messages.append(model)
        }
    }
}
