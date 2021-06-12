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
        
        guard case let .displayImage(message) = view.messages.first else {
            XCTFail("Wrong message type \(view.messages.first!)")
            return
        }
        XCTAssertEqual(view.messages.count, 1)
        XCTAssertEqual(message.title, model.title)
        XCTAssertEqual(message.author, model.author)
        XCTAssertNotNil(message.elapsedInterval)
        XCTAssertEqual(message.numberOfComments, model.numberOfComments)
        XCTAssertEqual(message.imageURL, model.imageURL)
        XCTAssertEqual(message.isLoading, true)
    }
    
    func test_didFinishLoadingImageData_Ok_displayViewModelWithImage() {
        let transformedData = AnyImage()
        let (sut, view) = makeSUT(imageTransformer: { _ in transformedData })
        let model = feedModel
        
        sut.didFinishLoadingImageData(with: Data(), for: model)
        
        guard case let .displayImage(message) = view.messages.first else {
            XCTFail("Wrong message type \(view.messages.first!)")
            return
        }
        XCTAssertEqual(view.messages.count, 1)
        XCTAssertEqual(message.title, model.title)
        XCTAssertEqual(message.author, model.author)
        XCTAssertNotNil(message.elapsedInterval)
        XCTAssertEqual(message.numberOfComments, model.numberOfComments)
        XCTAssertEqual(message.imageURL, model.imageURL)
        XCTAssertEqual(message.isLoading, false)
        XCTAssertEqual(message.thumbnail, transformedData)
    }
    
    func test_didFinishLoadingmageData_Error_displayViewModelWithoutImage() {
        let transformedData = AnyImage()
        let (sut, view) = makeSUT(imageTransformer: { _ in transformedData })
        let model = feedModel
        
        sut.didFinishLoadingImageData(with: anyNSError, for: model)
        
        guard case let .displayImage(message) = view.messages.first else {
            XCTFail("Wrong message type \(view.messages.first!)")
            return
        }
        XCTAssertEqual(view.messages.count, 1)
        XCTAssertEqual(message.title, model.title)
        XCTAssertEqual(message.author, model.author)
        XCTAssertNotNil(message.elapsedInterval)
        XCTAssertEqual(message.numberOfComments, model.numberOfComments)
        XCTAssertEqual(message.imageURL, model.imageURL)
        XCTAssertEqual(message.isLoading, false)
        XCTAssertEqual(message.thumbnail, nil)
    }
    
    func test_didStartSavingData_messageViewToStartLoading() {
        
    }
    
    // MARK: Helpers
    private var feedModel = FeedViewModel(item: sampleFeed)
    private struct AnyImage: Equatable {}
    
    private func makeSUT(imageTransformer: @escaping (Data) -> AnyImage? = { _ in nil },
                         file: StaticString = #file,
                         line: UInt = #line)
    -> (sut: ImagePresenter<ViewSpy, AnyImage>, view: ViewSpy) {
        let view = ViewSpy()
        let sut = ImagePresenter(view: view, cellDestructionView: view, imageTransformer: imageTransformer)
        
        trackForMemoryLeaks(view, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, view)
    }
    
    private class ViewSpy: ImagePresenterView, CellDestructionView {
        private(set) var messages = [Message]()
        
        enum Message {
            case displayImage(FeedImageViewModel<AnyImage>)
        }
        
        func display(_ model: FeedImageViewModel<AnyImage>) {
            messages.append(.displayImage(model))
        }
        
        func diplay(isSavingData: Bool) {
        }
        
        func diplay(didFinishSavingDataSuccessfully: Bool) {
            
        }
        
        func removeCell(at index: IndexPath) {
        }
    }
}
