//
//  SceneDelegate.swift
//  Reddit-Showcase
//
//  Created by Gustavo on 8/06/21.
//

import UIKit
import Combine

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

class AppState: ObservableObject  {
    @Published var currentPage = ""
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var appState = AppState()
    
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
        
        if let activity = session.stateRestorationActivity {
            appState.restore(from: activity)
        }
        
        configureWindow()
    }
    
    func configureWindow() {
        let controller = RedditFeedUIComposer.compose(state: appState,
                                                      feedLoader: MainThreadRedditTopFeedLoader(loader: feedloader),
                                                      imageLoader: MainThreadImageDataLoader(loader: imageLoader),
                                                      imageSaver: imageSaver)
        window?.rootViewController = UINavigationController(rootViewController: controller)
        window?.makeKeyAndVisible()
    }
    
    func stateRestorationActivity(for scene: UIScene) -> NSUserActivity? {
        let activity = NSUserActivity(activityType: Bundle.main.activityType)
        appState.store(in: activity)
        return activity
    }
}

extension AppState {
    func restore(from activity: NSUserActivity) {
        guard activity.activityType == Bundle.main.activityType,
            let currentPage = activity.userInfo?[Key.currentPage] as? String
            else { return }
        
        self.currentPage = currentPage
    }
    
    func store(in activity: NSUserActivity) {
        activity.addUserInfoEntries(from: [Key.currentPage: currentPage])
    }
    
    private enum Key {
        static let currentPage = "currentPage"
    }
}

extension Bundle {
    var activityType: String {
        return Bundle.main.infoDictionary?["NSUserActivityTypes"].flatMap { ($0 as? [String])?.first } ?? ""
    }
}
