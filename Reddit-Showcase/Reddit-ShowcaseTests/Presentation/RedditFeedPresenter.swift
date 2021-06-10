//
//  RedditFeedPresenter.swift
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
        
        XCTAssertEqual(view.messages, [.display(isLoading: false), .display(errorMessage: nil)])
    }
    
    // MARK: Helpers
    func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: RedditFeedPresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = RedditFeedPresenter(view: view)
        
        return (sut: sut, view: view)
    }
    
    class ViewSpy: RedditFeedView {
        enum Message: Hashable {
            case display(isLoading: Bool)
            case display(errorMessage: String?)
        }
        
        private(set) var messages = Set<Message>()
        
        func display(isLoading: Bool) {
            messages.insert(.display(isLoading: isLoading))
        }
        
        func display(_ viewModel: FeedErrorViewModel) {
            messages.insert(.display(errorMessage: viewModel.message))
        }
    }
}
