//
//  RedditFeedPresenter.swift
//  Reddit-Showcase
//
//  Created by Gustavo on 10/06/21.
//

import Foundation

public protocol RedditFeedView {
    func display(isLoading: Bool)
    func display(_ viewModel: FeedErrorViewModel)
}

public class RedditFeedPresenter {
    private let view: RedditFeedView
    
    public static var errorMessage: String {
        "That's a server error"
    }
    
    public init(view: RedditFeedView) {
        self.view = view
    }
    
    public func didStartLoading() {
        view.display(isLoading: true)
        view.display(.noError)
    }
    
    public func didFinishLoading(with error: Error) {
        view.display(isLoading: false)
        view.display(.error(message: RedditFeedPresenter.errorMessage))
    }
}
