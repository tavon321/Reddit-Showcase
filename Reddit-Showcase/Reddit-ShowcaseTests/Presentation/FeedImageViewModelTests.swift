//
//  FeedImageViewModelTests.swift
//  Reddit-ShowcaseTests
//
//  Created by Gustavo on 10/06/21.
//

import XCTest
import Reddit_Showcase

class FeedImageViewModelTests: XCTestCase {
    func test_elapsedInterval_displayFormmatedDate() {
        let dayAgoDateInterval = Date().adding(days: -1).timeIntervalSince1970
        let model = FeedImageViewModel<Any>(title: "Wooo sled racing",
                                            author: "t2_5qkq2got",
                                            entryDate: dayAgoDateInterval,
                                            numberOfComments: "669",
                                            imageURL: nil,
                                            thumbnail: nil,
                                            isLoading: false)
        
        XCTAssertEqual("1 day ago", model.elapsedInterval)
    }
}

extension Date {
    func adding(days: Int) -> Date {
        return Calendar(identifier: .gregorian).date(byAdding: .day, value: days, to: self)!
    }
}
