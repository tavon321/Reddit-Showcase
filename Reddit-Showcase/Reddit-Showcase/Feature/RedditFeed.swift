//
//  RedditFeed.swift
//  Reddit-Showcase
//
//  Created by Gustavo on 8/06/21.
//

import Foundation

public struct RedditFeedList: Decodable, Equatable {
    public var pagination: String?
    public var feedItems: [RedditFeed]
    
    enum CodingKeys: String, CodingKey {
        case pagination = "after"
        case feedItems = "children"
    }
    
    public init(pagination: String? = nil, feedItems: [RedditFeed]) {
        self.pagination = pagination
        self.feedItems = feedItems
    }
}

public struct RedditFeed: Decodable, Equatable {
    public let title: String
    public let author: String
    public let entryDate: Date
    public let numberOfComments: String
    public let thumbnail: URL?
    public let imageURL: URL?
    public let visited: Bool
    
    public init(title: String,
                author: String,
                entryDate: Date,
                numberOfComments: String,
                thumbnail: URL?,
                imageURL: URL?,
                visited: Bool) {
        self.title = title
        self.author = author
        self.entryDate = entryDate
        self.numberOfComments = numberOfComments
        self.thumbnail = thumbnail
        self.imageURL = imageURL
        self.visited = visited
    }
}
