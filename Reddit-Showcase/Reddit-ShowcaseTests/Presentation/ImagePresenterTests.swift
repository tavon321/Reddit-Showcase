//
//  ImagePresenterTests.swift
//  Reddit-ShowcaseTests
//
//  Created by Gustavo on 10/06/21.
//

import XCTest
import Reddit_Showcase

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
