//
//  RedditFeed.swift
//  Reddit-Showcase
//
//  Created by Gustavo on 8/06/21.
//

import Foundation

public struct RedditFeedList: Equatable {
    public var pagination: String?
    public var feedItems: [RedditFeed]
    
    public init(pagination: String? = nil, feedItems: [RedditFeed]) {
        self.pagination = pagination
        self.feedItems = feedItems
    }
}

public struct RedditFeed: Equatable {
    public let title: String
    public let name: String
    public let author: String
    public let entryDate: TimeInterval
    public let numberOfComments: String
    public let thumbnail: URL?
    public let imageURL: URL?
    public let visited: Bool
    
    public init(title: String,
                name: String,
                author: String,
                entryDate: TimeInterval,
                numberOfComments: String,
                thumbnail: URL?,
                imageURL: URL?,
                visited: Bool) {
        self.title = title
        self.name = name
        self.author = author
        self.entryDate = entryDate
        self.numberOfComments = numberOfComments
        self.thumbnail = thumbnail
        self.imageURL = imageURL
        self.visited = visited
    }
}
