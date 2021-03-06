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
        XCTAssertNotNil(message?.elapsedInterval)
        XCTAssertEqual(message?.numberOfComments, model.numberOfComments)
        XCTAssertEqual(message?.imageURL, model.imageURL)
        XCTAssertEqual(message?.isLoading, true)
    }
    
    func test_didFinishLoadingImageData_Ok_displayViewModelWithImage() {
        let transformedData = AnyImage()
        let (sut, view) = makeSUT(imageTransformer: { _ in transformedData })
        let model = feedModel
        
        sut.didFinishLoadingImageData(with: Data(), for: model)
        
        let message = view.messages.first
        XCTAssertEqual(view.messages.count, 1)
        XCTAssertEqual(message?.title, model.title)
        XCTAssertEqual(message?.author, model.author)
        XCTAssertNotNil(message?.elapsedInterval)
        XCTAssertEqual(message?.numberOfComments, model.numberOfComments)
        XCTAssertEqual(message?.imageURL, model.imageURL)
        XCTAssertEqual(message?.isLoading, false)
        XCTAssertEqual(message?.thumbnail, transformedData)
    }
    
    func test_didFinishLoadingmageData_Error_displayViewModelWithoutImage() {
        let transformedData = AnyImage()
        let (sut, view) = makeSUT(imageTransformer: { _ in transformedData })
        let model = feedModel
        
        sut.didFinishLoadingImageData(with: anyNSError, for: model)
        
        let message = view.messages.first
        XCTAssertEqual(view.messages.count, 1)
        XCTAssertEqual(message?.title, model.title)
        XCTAssertEqual(message?.author, model.author)
        XCTAssertNotNil(message?.elapsedInterval)
        XCTAssertEqual(message?.numberOfComments, model.numberOfComments)
        XCTAssertEqual(message?.imageURL, model.imageURL)
        XCTAssertEqual(message?.isLoading, false)
        XCTAssertEqual(message?.thumbnail, nil)
    }
    
    func test_didStartSavingData_messageViewToStartLoading() {
        let (sut, view) = makeSUT()
        
        sut.didStartSavingData()
        XCTAssertEqual(view.saveMessages, [.isSavingData(true)])
    }
    
    func test_didFinishSavingDataWithError_messageViewToStopLoadingAndDisplayError() {
        let (sut, view) = makeSUT()
        
        sut.didFinishSavingData(with: anyNSError)
        XCTAssertEqual(view.saveMessages, [.isSavingData(false), .displayError(true)])
    }
    
    func test_didFinishSavingDataSuccessfully_messageViewToStopLoadingAndDisplaySuccess() {
        let (sut, view) = makeSUT()
        
        sut.didFinishSavingData()
        XCTAssertEqual(view.saveMessages, [.isSavingData(false), .displayError(false)])
    }
    
    func test_deleteRowAtIndex_messageViewToDeleteRow() {
        let (sut, view) = makeSUT()
        let expetedIndex = IndexPath()
        
        sut.deleteRow(at: expetedIndex)
        
        XCTAssertEqual(view.saveMessages, [.delete(expetedIndex)])
    }
    
    func test_displayExpandedImage_messageViewToExpandImageWithURL() {
        let (sut, view) = makeSUT()
        let expectedUrl = anyURL
        
        sut.displayExpandedImage(with: expectedUrl)
        
        XCTAssertEqual(view.saveMessages, [.presentImage(expectedUrl)])
    }
    
    // MARK: Helpers
    private var feedModel = FeedViewModel(item: sampleFeed)
    private struct AnyImage: Equatable {}
    
    private func makeSUT(imageTransformer: @escaping (Data) -> AnyImage? = { _ in nil },
                         file: StaticString = #file,
                         line: UInt = #line)
    -> (sut: ImagePresenter<ViewSpy, AnyImage>, view: ViewSpy) {
        let view = ViewSpy()
        let sut = ImagePresenter(view: view,
                                 cellDestructionView: view,
                                 expandedImagePresenterView: view,
                                 imageTransformer: imageTransformer)
        
        trackForMemoryLeaks(view, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, view)
    }
    
    private class ViewSpy: ImagePresenterView, CellDestructionView, ExpandedImagePresenterView {
        
        
        private(set) var messages = [FeedImageViewModel<AnyImage>]()
        private(set) var saveMessages = [SaveMessage]()
        
        enum SaveMessage: Equatable {
            case isSavingData(Bool)
            case displayError(Bool)
            case delete(IndexPath)
            case presentImage(URL)
        }
        
        func display(_ model: FeedImageViewModel<AnyImage>) {
            messages.append(model)
        }
        
        func diplay(isSavingData: Bool) {
            saveMessages.append(.isSavingData(isSavingData))
        }
        
        func diplay(didFinishSavingDataSuccessfully: Bool) {
            saveMessages.append(.displayError(!didFinishSavingDataSuccessfully))
        }
        
        func removeCell(at index: IndexPath) {
            saveMessages.append(.delete(index))
        }
        
        func presentExpanedImage(at url: URL) {
            saveMessages.append(.presentImage(url))
        }
    }
}
