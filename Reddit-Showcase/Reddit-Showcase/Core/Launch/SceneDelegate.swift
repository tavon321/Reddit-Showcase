//
//  SceneDelegate.swift
//  Reddit-Showcase
//
//  Created by Gustavo on 8/06/21.
//

import UIKit

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
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        configureWindow()
    }
    
    func configureWindow() {
        let controller = RedditFeedUIComposer.compose(feedLoader: feedloader, imageLoader: imageLoader)
        window?.rootViewController = UINavigationController(rootViewController: controller)
        
        window?.makeKeyAndVisible()
    }
}
