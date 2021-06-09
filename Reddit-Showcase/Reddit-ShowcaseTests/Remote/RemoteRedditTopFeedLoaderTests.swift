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
    
//    func test_loadFeed_deliversEmptyFeedOn200WithEmptyFeedData() {
//        let (sut, client) = makeSUT(url: anyURL)
//
//        expect(sut, toCompleteWith: .success([])) {
//            client.complete(statusCode: 200, data: makeFeedJson)
//        }
//    }
//
    // MARK: - Helpers
    private var anyURL: URL{ URL(string: "https://any-url.com")! }
    private var anyPage: String { "any-page" }
    private var anyLimit: String { "50" }
    private var anyNSError: NSError { NSError(domain: "any error", code: 0) }
    
    private func makeFeedJson(_ feed: [Any]) -> Data {
        let json = ["data": ["children": feed]]
       return try! JSONSerialization.data(withJSONObject: json)
    }
    
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
        
        func complete(statusCode: Int, data: Data, at index: Int = 0) {
            let response = HTTPURLResponse(url: requestedUrls[index],
                                           statusCode: statusCode,
                                           httpVersion: nil,
                                           headerFields: [:])!
            completions[index](.success((data, response)))
        }
    }
}
