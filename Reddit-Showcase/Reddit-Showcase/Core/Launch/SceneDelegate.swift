//
//  SceneDelegate.swift
//  Reddit-Showcase
//
//  Created by Gustavo on 8/06/21.
//

import UIKit

class MainThreadRedditTopFeedLoader: RedditTopFeedLoader {
    private let loader: RedditTopFeedLoader
    
    internal init(loader: RedditTopFeedLoader) {
        self.loader = loader
    }
    
    func loadFeed(page: String, completion: @escaping (RedditTopFeedLoader.Result) -> Void) {
        loader.loadFeed(page: page) { result in
            guaranteeMainThread {
                completion(result)
            }
        }
    }
}

class MainThreadImageDataLoader: ImageDataLoader {
    private let loader: ImageDataLoader
    
    internal init(loader: ImageDataLoader) {
        self.loader = loader
    }
    
    func loadImageData(from url: URL, completion: @escaping (ImageDataLoader.Result) -> Void) -> HTTPClientTask {
        loader.loadImageData(from: url) { result in
            guaranteeMainThread {
                completion(result)
            }
        }
    }
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    private lazy var httpClient: HTTPClient = {
        URLSessionHTTPClient()
    }()
    
    private lazy var feedloader: RemoteRedditTopFeedLoader = {
        let remoteURL = URL(string: "https://www.reddit.com/top.json")!
        return RemoteRedditTopFeedLoader(url: remoteURL, limit: "50", client: httpClient)
    }()
    
    private lazy var imageLoader: RemoteImageDataLoader = {
        return RemoteImageDataLoader(client: httpClient)
    }()
    
    private lazy var imageSaver: LibraryImageSaver = {
        return LibraryImageSaver(photoLibrary: UIPhotoLibrary(), imageTransformer: UIImage.init)
    }()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        configureWindow()
    }
    
    func configureWindow() {
        let controller = RedditFeedUIComposer.compose(feedLoader: MainThreadRedditTopFeedLoader(loader: feedloader),
                                                      imageLoader: MainThreadImageDataLoader(loader: imageLoader),
                                                      imageSaver: imageSaver)
        window?.rootViewController = UINavigationController(rootViewController: controller)
        
        window?.makeKeyAndVisible()
    }
}
