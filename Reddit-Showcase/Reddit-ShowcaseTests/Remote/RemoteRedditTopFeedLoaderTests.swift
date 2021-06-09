//
//  RemoteRedditTopFeedLoaderTests.swift
//  Reddit-ShowcaseTests
//
//  Created by Gustavo on 9/06/21.
//

import XCTest

protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    
    func load(url: URL, completion: @escaping (Result) -> Void)
}

class RemoteRedditTopFeedLoader {
    private let url: URL
    private let client: HTTPClient
    
    public typealias Result = Error
    
    enum Error: Swift.Error {
        case connectivity
    }
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client =  client
    }
    
    func load(page: String, limit: String, completion: @escaping (Result) -> Void) {
        client.load(url: make(url: url, with: page, limit: limit)) { _ in
            completion(.connectivity)
        }
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
        
        sut.load(page: expectedPage, limit: expectedLimit) { _ in }
        
        let expectedUrl = url(baseUrl, with: expectedPage, limit: expectedLimit)
        XCTAssertEqual(client.requestedUrls, [expectedUrl])
    }
    
    func test_loadFeedTwice_requestFromClientTwice() {
        let expectedPage = anyPage
        let expectedLimit = anyLimit
        let baseUrl = anyURL
        
        let (sut, client) = makeSUT(url: baseUrl)
        
        sut.load(page: expectedPage, limit: expectedLimit) { _ in }
        sut.load(page: expectedPage, limit: expectedLimit) { _ in }
        
        let expectedUrl = url(baseUrl, with: expectedPage, limit: expectedLimit)
        XCTAssertEqual(client.requestedUrls, [expectedUrl, expectedUrl])
    }
    
    func test_loadFeed_deliversConnectivityErrorOnClientsError() {
        let (sut, client) = makeSUT(url: anyURL)

        expect(sut,
               toCompleteWith: .connectivity) {
            client.complete(with: anyNSError)
        }
    }
    
    // MARK: - Helpers
    private var anyURL: URL{ URL(string: "https://any-url.com")! }
    private var anyPage: String { "any-page" }
    private var anyLimit: String { "50" }
    private var anyNSError: NSError { NSError(domain: "any error", code: 0) }
    
    private func url(_ url: URL, with page: String, limit: String) -> URL {
        let queryItems = [URLQueryItem(name: "limit", value: limit), URLQueryItem(name: "after", value: page)]
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = queryItems
        
        return urlComponents!.url!
    }
    
    private func expect(_ sut: RemoteRedditTopFeedLoader,
                        toCompleteWith expectedResult: RemoteRedditTopFeedLoader.Result,
                        file: StaticString = #file,
                        line: UInt = #line,
                        when action: () -> Void) {
        let exp = expectation(description: "wait for result")
        sut.load(page: anyPage, limit: anyLimit) { receivedResult in
            XCTAssertEqual(expectedResult, .connectivity)
            exp.fulfill()
        }
        
        action()
        wait(for: [exp], timeout: 0.1)
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
        private(set) var completions = [(HTTPClient.Result) -> Void]()
        
        func load(url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
            requestedUrls.append(url)
            completions.append(completion)
        }
        
        func complete(with error: Error, at index: Int = 0) {
            completions[index](.failure(error))
        }
    }
}
