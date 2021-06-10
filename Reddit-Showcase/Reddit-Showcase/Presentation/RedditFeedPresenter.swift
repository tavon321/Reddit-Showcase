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
    
    public init(view: RedditFeedView) {
        self.view = view
    }
    
    public func didStartLoading() {
        view.display(isLoading: false)
        view.display(.noError)
    }
}
