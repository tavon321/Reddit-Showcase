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
    
    private final class HTTPClientTaskWrapper: HTTPClientTask {
        private var completion: ((Result) -> Void)?
        
        var wrapped: HTTPClientTask?
        
        init(_ completion: @escaping (Result) -> Void) {
            self.completion = completion
        }
        
        func complete(with result: Result) {
            completion?(result)
        }
        
        func cancel() {
            completion = nil
            wrapped?.cancel()
        }
    }

    public func loadImageData(from url: URL, completion: @escaping (Result) -> Void) -> HTTPClientTask {
        let task = HTTPClientTaskWrapper(completion)
        task.wrapped = client.load(url: url) { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case let .success((data, response)):
                guard response.isOK && !data.isEmpty else {
                    task.complete(with: .failure(Error.invalidData))
                    return
                }
                task.complete(with: .success(data))
            case .failure:
                task.complete(with: .failure(Error.connectivity))
            }
        }
        return task
    }
}
