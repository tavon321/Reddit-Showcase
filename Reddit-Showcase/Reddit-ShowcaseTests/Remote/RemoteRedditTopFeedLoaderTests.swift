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
    
    func load(page: String, limit: String) {
        client.load(url: make(url: url, with: page, limit: limit))
    }
    
    private func make(url: URL, with page: String, limit: String) -> URL {
        let queryItems = [URLQueryItem(name: "limit", value: limit), URLQueryItem(name: "after", value: page)]
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = queryItems
        
        return urlComponents!.url!
    }
}

class RemoteRedditTopFeedLoaderTests: XCTestCase {
    func test_init_doesNotMessageClient() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedUrls.isEmpty)
    }
    
    func test_loadFeed_messageClientWithURLAndParameters() {
        let expectedPage = anyPage
        let expectedLimit = anyLimit
        let baseUrl = anyURL
        
        let (sut, client) = makeSUT(url: baseUrl)
        
        sut.load(page: expectedPage, limit: expectedLimit)
        let expectedUrl = url(baseUrl, with: expectedPage, limit: expectedLimit)
        XCTAssertEqual(client.requestedUrls, [expectedUrl])
    }
    
    func test_loadFeedTwice_requestFromClientTwice() {
        let expectedPage = anyPage
        let expectedLimit = anyLimit
        let baseUrl = anyURL
        
        let (sut, client) = makeSUT(url: baseUrl)
        
        sut.load(page: expectedPage, limit: expectedLimit)
        sut.load(page: expectedPage, limit: expectedLimit)
        
        let expectedUrl = url(baseUrl, with: expectedPage, limit: expectedLimit)
        XCTAssertEqual(client.requestedUrls, [expectedUrl, expectedUrl])
    }
    
    // MARK: - Helpers
    private var anyURL: URL{ URL(string: "https://any-url.com")! }
    private var anyPage: String { "any-page" }
    private var anyLimit: String { "50" }
    
    func url(_ url: URL, with page: String, limit: String) -> URL {
        let queryItems = [URLQueryItem(name: "limit", value: limit), URLQueryItem(name: "after", value: page)]
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = queryItems
        
        return urlComponents!.url!
    }
    
    private func makeSUT(url: URL = URL(string: "https://any-url.com")!,
                         file: StaticString = #file,
                         line: UInt = #line)
    -> (sut: RemoteRedditTopFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteRedditTopFeedLoader(url: url, client: client)
        
        trackForMemoryLeaks(client, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut: sut, client: client)
    }
    
    private class HTTPClientSpy: HTTPClient {
        private(set) var requestedUrls = [URL]()
        
        func load(url: URL) {
            requestedUrls.append(url)
        }
    }
}
