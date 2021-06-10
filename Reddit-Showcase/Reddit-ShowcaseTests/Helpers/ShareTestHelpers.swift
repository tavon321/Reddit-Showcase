//
//  ShareTestHelpers.swift
//  Reddit-ShowcaseTests
//
//  Created by Gustavo on 9/06/21.
//

import Foundation
import Reddit_Showcase

var anyNSError: NSError { NSError(domain: "any error", code: 0) }
var anyURL: URL{ URL(string: "https://any-url.com")! }

var sampleFeedList = makeFeed([sampleFeed],
                              pagination: "t3_nv6kri")
var sampleFeed: RedditFeed {
    RedditFeed(title: "Wooo sled racing",
               author: "t2_5qkq2got",
               entryDate: 1623195130.0,
               numberOfComments: "669",
               thumbnail: URL(string: "https://b.thumbs.redditmedia.com/uXMEsf-87n4kIa_v93T_lmzKP5BjV-MC4appd9eXbio.jpg")!,
               imageURL: URL(string: "https://v.redd.it/7uce6qeb62471.jpg"),
               visited: false)
}

func makeFeed(_ feed: [RedditFeed], pagination: String? = nil) -> RedditFeedList {
    RedditFeedList(pagination: pagination, feedItems: feed)
}

