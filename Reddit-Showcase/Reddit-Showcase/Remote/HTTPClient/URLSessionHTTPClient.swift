//
//  URLSessionHTTPClient.swift
//  Reddit-Showcase
//
//  Created by Gustavo on 9/06/21.
//

import Foundation

public class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    struct UnexpectedValue: Error { }
    
    public func load(url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
        session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data , let response = response as? HTTPURLResponse {
                completion(.success((data, response)))
            } else {
                completion(.failure(UnexpectedValue()))
            }
        }.resume()
    }
}