//
//  RedditFeedPresenter.swift
//  Reddit-ShowcaseTests
//
//  Created by Gustavo on 10/06/21.
//

import XCTest

public struct FeedErrorViewModel {
    public let message: String?
    
    static var noError: FeedErrorViewModel {
        return FeedErrorViewModel(message: nil)
    }
    
    static func error(message: String) -> FeedErrorViewModel {
        return FeedErrorViewModel(message: message)
    }
}

public protocol RedditFeedView {
    func display(isLoading: Bool)
    func display(_ viewModel: FeedErrorViewModel)
}

public class RedditFeedPresenter {
    private let view: RedditFeedView
    
    public init(view: RedditFeedView) {
        self.view = view
    }
    
    public func didStartLoading() {
        view.display(isLoading: false)
        view.display(.noError)
    }
}

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
