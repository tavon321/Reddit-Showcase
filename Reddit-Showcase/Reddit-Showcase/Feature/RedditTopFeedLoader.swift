//
//  RedditTopFeedLoader.swift
//  Reddit-Showcase
//
//  Created by Gustavo on 8/06/21.
//

import Foundation

public protocol RedditTopFeedLoader {
    typealias Result = Swift.Result<[RedditFeedList], Error>
    
    func loadFeed(page: String, limit: Int)
}
