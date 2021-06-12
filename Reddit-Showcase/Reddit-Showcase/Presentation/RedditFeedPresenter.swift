//
//  RedditFeedPresenter.swift
//  Reddit-Showcase
//
//  Created by Gustavo on 10/06/21.
//

import Foundation

public protocol RedditFeedView: AnyObject {
    func display(isLoading: Bool)
    func display(_ viewModel: FeedErrorViewModel)
}

public protocol RedditListView: AnyObject {
    func display(_ viewModel: FeedListViewModel)
}

public class RedditFeedPresenter {
    private weak var view: RedditFeedView?
    private let listView: RedditListView
    
    public static var errorMessage: String {
        "That's a server error"
    }
    
    public init(view: RedditFeedView, listView: RedditListView) {
        self.view = view
        self.listView = listView
    }
    
    public func didStartLoading() {
        view?.display(isLoading: true)
        view?.display(.noError)
    }
    
    public func didFinishLoading(with error: Error) {
        view?.display(isLoading: false)
        view?.display(.error(message: RedditFeedPresenter.errorMessage))
    }
    
    public func didFinishLoading(with feedList: RedditFeedList) {
        view?.display(isLoading: false)
        listView.display(.init(feedList: feedList))
    }
}
