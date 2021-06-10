//
//  RedditFeedPresenter.swift
//  Reddit-Showcase
//
//  Created by Gustavo on 10/06/21.
//

import Foundation

public struct FeedListViewModel: Hashable {
    public var pagination: String?
    public var feedViewModels: [FeedViewModel]
    
    public init(feedList: RedditFeedList) {
        self.pagination = feedList.pagination
        self.feedViewModels = feedList.feedItems.map {
            FeedViewModel(item: $0)
        }
    }
}

public struct FeedViewModel: Hashable {
    public let title: String
    public let author: String
    private let entryDate: TimeInterval
    public let numberOfComments: String
    public let thumbnail: URL?
    public let imageURL: URL?
    public let visited: Bool
    
    public init(item: RedditFeed) {
        self.title = item.title
        self.author = item.author
        self.entryDate = item.entryDate
        self.numberOfComments = item.numberOfComments
        self.thumbnail = item.thumbnail
        self.imageURL = item.imageURL
        self.visited = item.visited
    }
    
    public var elapsedInterval: String {
        Date(timeIntervalSince1970: entryDate).getElapsedInterval()
    }
}

public protocol RedditFeedView {
    func display(isLoading: Bool)
    func display(_ viewModel: FeedErrorViewModel)
    func display(_ viewModel: FeedListViewModel)
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
    
    public func didFinishLoading(with feedList: RedditFeedList) {
        view.display(isLoading: false)
        view.display(.init(feedList: feedList))
    }
}
