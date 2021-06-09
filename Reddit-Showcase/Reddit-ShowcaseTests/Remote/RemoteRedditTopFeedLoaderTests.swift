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
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedUrls.isEmpty)
    }
    
    func test_loadFeed_messageClientWithURL() {
        let expectedUrl = anyURL
        let (sut, client) = makeSUT(url: expectedUrl)
        
        sut.load()
        
        XCTAssertEqual(client.requestedUrls, [expectedUrl])
    }
    
    // MARK: - Helpers
    private let anyURL = URL(string: "https://any-url.com")!
    
    private func makeSUT(url: URL = URL(string: "https://any-url.com")!)
    -> (sut: RemoteRedditTopFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteRedditTopFeedLoader(url: url, client: client)
        
        return (sut: sut, client: client)
    }
    
    private class HTTPClientSpy: HTTPClient {
        private(set) var requestedUrls = [URL]()
        
        func load(url: URL) {
            requestedUrls.append(url)
        }
    }
}
