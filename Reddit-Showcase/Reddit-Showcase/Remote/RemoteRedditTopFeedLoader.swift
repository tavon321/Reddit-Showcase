//
//  RemoteRedditTopFeedLoader.swift
//  Reddit-Showcase
//
//  Created by Gustavo on 9/06/21.
//

import Foundation

public class RemoteRedditTopFeedLoader: RedditTopFeedLoader {
    private let url: URL
    private let limit: String
    private let client: HTTPClient
    
    public typealias Result = RedditTopFeedLoader.Result
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public init(url: URL, limit: String, client: HTTPClient) {
        self.url = url
        self.client =  client
        self.limit = limit
    }
    
    public func loadFeed(page: String, completion: @escaping (Result) -> Void) {
        client.load(url: make(url: url, with: page, limit: limit)) { result in
            switch result {
            case let .success((_, response)):
                guard response.isOK else {
                    completion(.failure(Error.invalidData))
                    return
                }
            default:
                completion(.failure(Error.connectivity))
            }
        }
    }
    
    private func make(url: URL, with page: String, limit: String) -> URL {
        let queryItems = [URLQueryItem(name: "limit", value: limit), URLQueryItem(name: "after", value: page)]
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = queryItems
        
        return urlComponents!.url!
    }
}
