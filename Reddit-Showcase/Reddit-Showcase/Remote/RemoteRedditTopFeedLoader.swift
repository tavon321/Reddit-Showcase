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
            case let .success((data, response)):
                completion(RemoteRedditTopFeedLoader.map(data: data, response: response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
    
    private static func map(data: Data, response: HTTPURLResponse) -> Result {
        do {
            let remote = try RemoteRedditTopFeedMapper.map(data: data, response: response)
            return .success(remote.toModel())
        } catch {
            return .failure(error)
        }
    }
    
    private func make(url: URL, with page: String, limit: String) -> URL {
        let queryItems = [URLQueryItem(name: "limit", value: limit), URLQueryItem(name: "after", value: page)]
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = queryItems
        
        return urlComponents!.url!
    }
}

internal final class RemoteRedditTopFeedMapper {
    struct Root: Decodable {
        let data: List
    }
    
    struct List: Decodable {
        let after: String?
        let children: [Children]
    }
    
    struct Children: Decodable {
        let data: RemoteRedditFeed
    }

    static func map(data: Data, response: HTTPURLResponse) throws -> RemoteRedditFeedList {
        guard response.isOK, let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw RemoteRedditTopFeedLoader.Error.invalidData
        }
        
        return RemoteRedditFeedList(pagination: root.data.after,
                                    feedItems: root.data.children.map({ $0.data }))
    }
}

