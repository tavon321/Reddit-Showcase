//
//  RemoteRedditTopFeedLoaderTests.swift
//  Reddit-ShowcaseTests
//
//  Created by Gustavo on 9/06/21.
//

import XCTest

protocol HTTPClient {
}

class RemoteRedditTopFeedLoader {
    private let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client =  client
    }
}


class RemoteRedditTopFeedLoaderTests: XCTestCase {
    func test_init_doesNotMessageClient() {
        let client = HTTPClientSpy()
        _ = RemoteRedditTopFeedLoader(client: client)
        
        XCTAssertTrue(client.callCount == 0)
    }
    
    // MARK: - Helpers
    class HTTPClientSpy: HTTPClient {
        var callCount = 0
    }
}
