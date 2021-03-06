//
//  RedditFeedPresenterTests.swift
//  Reddit-ShowcaseTests
//
//  Created by Gustavo on 10/06/21.
//

import XCTest
import Reddit_Showcase

class RedditFeedPresenterTests: XCTestCase {
    
    func test_init_doesNotSendMessagesToView() {
        let (_, view) = makeSUT()

        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }
    
    func test_didStartLoading_hidesErrorAndStartsLoading() {
        let (sut, view) = makeSUT()
        
        sut.didStartLoading()
        
        XCTAssertEqual(view.messages, [.display(isLoading: true), .display(errorMessage: nil)])
    }
    
    func test_didFinishLoadingWithError_stopsLoadingAndPresentError() {
        let (sut, view) = makeSUT()
        
        sut.didFinishLoading(with: anyNSError)
        
        XCTAssertEqual(view.messages, [.display(isLoading: false),
                                       .display(errorMessage: RedditFeedPresenter.errorMessage)])
    }
    
    func test_didFinishLoadingWithFeed_stopsLoadingAndDeliverFormatterFeed() {
        let (sut, view) = makeSUT()
        let expectedFeedList = sampleFeedList
        
        sut.didFinishLoading(with: expectedFeedList)
        
        XCTAssertEqual(view.messages, [.display(isLoading: false),
                                       .display(feedListViewModel: FeedListViewModel(feedList: expectedFeedList))])
    }
    
    // MARK: Helpers
    func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: RedditFeedPresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = RedditFeedPresenter(view: view, listView: view)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(view, file: file, line: line)
        
        return (sut: sut, view: view)
    }
    
    class ViewSpy: RedditFeedView, RedditListView {
        enum Message: Hashable {
            case display(isLoading: Bool)
            case display(errorMessage: String?)
            case display(feedListViewModel: FeedListViewModel)
        }
        
        private(set) var messages = Set<Message>()
        
        func display(isLoading: Bool) {
            messages.insert(.display(isLoading: isLoading))
        }
        
        func display(_ viewModel: FeedErrorViewModel) {
            messages.insert(.display(errorMessage: viewModel.message))
        }
        
        func display(_ viewModel: FeedListViewModel) {
            messages.insert(.display(feedListViewModel: viewModel))
        }
    }
}
