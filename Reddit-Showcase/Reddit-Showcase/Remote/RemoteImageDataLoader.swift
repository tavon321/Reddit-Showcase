//
//  RemoteImageDataLoader.swift
//  Reddit-Showcase
//
//  Created by Gustavo on 10/06/21.
//

import Foundation

public protocol ImageDataLoader {
    typealias Result = Swift.Result<Data, Error>
    
    func loadImageData(from url: URL, completion: @escaping (Result) -> Void) -> HTTPClientTask
}

public final class RemoteImageDataLoader: ImageDataLoader {
    private let client: HTTPClient
    
    public typealias Result = ImageDataLoader.Result
    
    public init(client: HTTPClient) {
        self.client = client
    }
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }

    public func loadImageData(from url: URL, completion: @escaping (Result) -> Void) -> HTTPClientTask {
        let task = client.load(url: url) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case let .success((data, response)):
                guard response.isOK && !data.isEmpty else {
                    completion(.failure(Error.invalidData))
                    return
                }
                completion(.success(data))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
        return task
    }
}
