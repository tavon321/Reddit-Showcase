//
//  RemoteRedditFeed.swift
//  Reddit-Showcase
//
//  Created by Gustavo on 9/06/21.
//

import Foundation

public struct RemoteRedditFeedList: Decodable {
    public var pagination: String?
    public var feedItems: [RemoteRedditFeed]
    
    enum CodingKeys: String, CodingKey {
        case pagination = "after"
        case feedItems = "children"
    }
    
    public init(pagination: String? = nil, feedItems: [RemoteRedditFeed]) {
        self.pagination = pagination
        self.feedItems = feedItems
    }
}

public struct RemoteRedditFeed: Decodable {
    public let title: String
    public let name: String
    public let author: String
    public let entryDate: TimeInterval
    public let numberOfComments: Int
    public let thumbnail: URL?
    public let imageURL: URL?
    public let visited: Bool
    
    public init(title: String,
                name: String,
                author: String,
                entryDate: TimeInterval,
                numberOfComments: Int,
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
    
    enum CodingKeys: String, CodingKey {
        case title
        case name
        case author = "author_fullname"
        case entryDate = "created"
        case numberOfComments = "num_comments"
        case thumbnail
        case imageURL = "url"
        case visited
    }
}

extension RemoteRedditFeedList {
    func toModel() -> RedditFeedList {
        RedditFeedList(pagination: pagination, feedItems: feedItems.mapModels())
    }
}

extension Array where Element == RemoteRedditFeed {
    func mapModels() -> [RedditFeed] {
        return self.map {
            let imageURL = $0.imageURL?.pathExtension == "jpg" ? $0.imageURL : nil
            return RedditFeed(title: $0.title,
                              name: $0.name,
                              author: $0.author,
                              entryDate: $0.entryDate,
                              numberOfComments: "\($0.numberOfComments)",
                              thumbnail: $0.thumbnail,
                              imageURL: imageURL,
                              visited: $0.visited)
        }
    }
}
