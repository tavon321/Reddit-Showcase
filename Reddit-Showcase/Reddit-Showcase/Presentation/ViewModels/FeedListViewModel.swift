//
//  FeedListViewModel.swift
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
    public let name: String
    public let author: String
    public let entryDate: TimeInterval
    public let numberOfComments: String
    public let thumbnail: URL?
    public let imageURL: URL?
    
    public init(item: RedditFeed) {
        self.title = item.title
        self.name = item.name
        self.author = item.author
        self.entryDate = item.entryDate
        self.numberOfComments = item.numberOfComments
        self.thumbnail = item.thumbnail
        self.imageURL = item.imageURL
    }
}
