//
//  RedditFeed.swift
//  Reddit-Showcase
//
//  Created by Gustavo on 8/06/21.
//

import Foundation

public struct RedditFeedList {
    var pagination: String?
    var feedItems: [RedditFeed]
}

public struct RedditFeed {
    let title: String
    let author: String
    let entryDate: Date
    let numberOfComments: String
    let thumbnail: URL?
    let imageURL: URL?
    let visited: Bool
}
