//
//  RemoteRedditTopFeedLoaderTests.swift
//  Reddit-ShowcaseTests
//
//  Created by Gustavo on 9/06/21.
//

import XCTest

protocol HTTPClient {
    func load(url: URL)
}

class RemoteRedditTopFeedLoader {
    private let url: URL
    private let client: HTTPClient
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client =  client
    }
    
    func load() {
        client.load(url: url)
    }
}

class RemoteRedditTopFeedLoaderTests: XCTestCase {
    func test_init_doesNotMessageClient() {
        let client = HTTPClientSpy()
        _ = RemoteRedditTopFeedLoader(url: anyURL, client: client)
        
        XCTAssertTrue(client.callCount == 0)
    }
    
    func test_loadFeed_messageClientWithURL() {
        let expectedUrl = anyURL
        let client = HTTPClientSpy()
        let sut = RemoteRedditTopFeedLoader(url: expectedUrl, client: client)
        
        sut.load()
        
        XCTAssertEqual(client.requestedUrls, [expectedUrl])
    }
    
    // MARK: - Helpers
    private let anyURL = URL(string: "https://any-url.com")!
    
    private class HTTPClientSpy: HTTPClient {
        private(set) var requestedUrls = [URL]()
        var callCount = 0
        
        func load(url: URL) {
            requestedUrls.append(url)
            callCount += 1
        }
    }
}
