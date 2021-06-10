//
//  HTTPClientSpy.swift
//  Reddit-ShowcaseTests
//
//  Created by Gustavo on 10/06/21.
//

import Foundation
import Reddit_Showcase

class HTTPClientSpy: HTTPClient {
    private struct Task: HTTPClientTask {
        let callback: () -> Void
        func cancel() { callback() }
    }
    
    private(set) var requestedUrls = [URL]()
    private(set) var completions = [(HTTPClient.Result) -> Void]()
    private(set) var cancelledURLs = [URL]()
    
    @discardableResult
    func load(url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        requestedUrls.append(url)
        completions.append(completion)
        
        return Task { [weak self] in
            self?.cancelledURLs.append(url)
        }
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
