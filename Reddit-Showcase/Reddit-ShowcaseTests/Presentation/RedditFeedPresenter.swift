//
//  RedditFeedPresenter.swift
//  Reddit-ShowcaseTests
//
//  Created by Gustavo on 10/06/21.
//

import XCTest

protocol RedditFeedView {
}

class RedditFeedPresenter {
    private let view: RedditFeedView
    
    init(view: RedditFeedView) {
        self.view = view
    }
}

class RedditFeedPresenterTests: XCTestCase {
    
    func test_init_doesNotSendMessagesToView() {
        let (_, view) = makeSUT()

        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }
    
    // MARK: Helpers
    func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: RedditFeedPresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = RedditFeedPresenter(view: view)
        
        return (sut: sut, view: view)
    }
    
    class ViewSpy: RedditFeedView {
        enum Message: Hashable {
            
        }
        
        private(set) var messages = Set<Message>()
    }
}
