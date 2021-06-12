//
//  RemoteRedditTopFeedLoaderTests.swift
//  Reddit-ShowcaseTests
//
//  Created by Gustavo on 9/06/21.
//

import XCTest
import Reddit_Showcase

class RemoteRedditTopFeedLoaderTests: XCTestCase {
    func test_init_doesNotMessageClient() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedUrls.isEmpty)
    }
    
    func test_loadFeed_messageClientWithURLAndParameters() {
        let expectedPage = anyPage
        let expectedLimit = anyLimit
        let baseUrl = anyURL
        
        let (sut, client) = makeSUT(url: baseUrl, limit: expectedLimit)
        
        sut.loadFeed(page: expectedPage) { _ in }
        
        let expectedUrl = url(baseUrl, with: expectedPage, limit: expectedLimit)
        XCTAssertEqual(client.requestedUrls, [expectedUrl])
    }
    
    func test_loadFeedTwice_requestFromClientTwice() {
        let expectedPage = anyPage
        let expectedLimit = anyLimit
        let baseUrl = anyURL
        
        let (sut, client) = makeSUT(url: baseUrl, limit: expectedLimit)
        
        sut.loadFeed(page: expectedPage) { _ in }
        sut.loadFeed(page: expectedPage) { _ in }
        
        let expectedUrl = url(baseUrl, with: expectedPage, limit: expectedLimit)
        XCTAssertEqual(client.requestedUrls, [expectedUrl, expectedUrl])
    }
    
    func test_loadFeed_deliversConnectivityErrorOnClientsError() {
        let (sut, client) = makeSUT(url: anyURL)
        
        expect(sut, toCompleteWith: failure(.connectivity)) {
            client.complete(with: anyNSError)
        }
    }
    
    func test_loadFeed_deliversInvalidDataErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT(url: anyURL)
        let statusCodes = [199, 201, 400, 500]
        
        statusCodes.enumerated().forEach { (index, statusCode) in
            expect(sut, toCompleteWith: failure(.invalidData)) {
                client.complete(statusCode: statusCode, data: Data(), at: index)
            }
        }
    }
    
    func test_loadFeed_deliversEmptyFeedOn200WithEmptyFeedData() {
        let (sut, client) = makeSUT(url: anyURL)
        let emptyFeedItem = makeFeed([])
        
        expect(sut, toCompleteWith: .success(emptyFeedItem)) {
            let emptyJsonData = loadJson(named: "EmptyFeed")!
            client.complete(statusCode: 200, data: emptyJsonData)
        }
    }
    
    func test_loadFeed_doesNotRequestAfterSUTHAsBeenDeallocated() {
        let client = HTTPClientSpy()
        var sut: RemoteRedditTopFeedLoader? = RemoteRedditTopFeedLoader(url: anyURL, limit: "0", client: client)
        
        var capturedResult: RemoteRedditTopFeedLoader.Result?
        sut?.loadFeed(page: "", completion: { result in
            capturedResult = result
        })
        
        sut = nil
        client.complete(with: anyNSError)
        
        XCTAssertNil(capturedResult)
    }
    
    func test_loadFeed_deliversFeedOn200WithFeedData() {
        let (sut, client) = makeSUT(url: anyURL)
        let feedItem = makeFeed([RedditFeed(title: "Wooo sled racing",
                                            name: "t3_nv6kri",
                                            author: "t2_5qkq2got",
                                            entryDate: 1623195130.0,
                                            numberOfComments: "669",
                                            thumbnail: URL(string: "https://b.thumbs.redditmedia.com/uXMEsf-87n4kIa_v93T_lmzKP5BjV-MC4appd9eXbio.jpg")!,
                                            imageURL: URL(string: "https://v.redd.it/7uce6qeb62471.jpg"),
                                            visited: false)],
                                pagination: "t3_nv6kri")
        
        expect(sut, toCompleteWith: .success(feedItem)) {
            let jsonData = loadJson(named: "FeedWithOneItem")!
            client.complete(statusCode: 200, data: jsonData)
        }
    }
    
    // MARK: - Helpers
    private var anyPage: String { "any-page" }
    private var anyLimit: String { "50" }
    
    private func failure(_ error: RemoteRedditTopFeedLoader.Error) -> RemoteRedditTopFeedLoader.Result {
        return .failure(error)
    }
    
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
        sut.loadFeed(page: anyPage) { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedFeedList), .success(expectedFeedlist)):
                XCTAssertEqual(receivedFeedList, expectedFeedlist, file: file, line: line)
            case let (.failure(receivedError as RemoteRedditTopFeedLoader.Error),
                      .failure(expectedError as RemoteRedditTopFeedLoader.Error)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            default:
                XCTFail("Expected \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        action()
        wait(for: [exp], timeout: 0.1)
    }
    
    private func makeSUT(url: URL = URL(string: "https://any-url.com")!,
                         limit: String = "1",
                         file: StaticString = #file,
                         line: UInt = #line)
    -> (sut: RemoteRedditTopFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteRedditTopFeedLoader(url: url, limit: limit, client: client)
        
        trackForMemoryLeaks(client, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut: sut, client: client)
    }
    
}
