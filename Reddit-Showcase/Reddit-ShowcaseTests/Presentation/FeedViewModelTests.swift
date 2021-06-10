//
//  FeedViewModelTests.swift
//  Reddit-ShowcaseTests
//
//  Created by Gustavo on 10/06/21.
//

import XCTest
import Reddit_Showcase

class FeedViewModelTests: XCTestCase {
    func test_elapsedInterval_displayFormmatedDate() {
        let dayAgoDateInterval = Date().adding(days: -1).timeIntervalSince1970
        let feed = RedditFeed(title: "Wooo sled racing",
                              author: "t2_5qkq2got",
                              entryDate: dayAgoDateInterval,
                              numberOfComments: "669",
                              thumbnail: URL(string: "https://b.thumbs.redditmedia.com/uXMEsf-87n4kIa_v93T_lmzKP5BjV-MC4appd9eXbio.jpg")!,
                              imageURL: URL(string: "https://v.redd.it/7uce6qeb62471.jpg"),
                              visited: false)
        let sut = FeedViewModel(item: feed)
        
        XCTAssertEqual("1 day ago", sut.elapsedInterval)
    }
}

extension Date {
    func adding(days: Int) -> Date {
        return Calendar(identifier: .gregorian).date(byAdding: .day, value: days, to: self)!
    }
}
