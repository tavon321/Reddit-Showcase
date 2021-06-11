//
//  SceneDelegate.swift
//  Reddit-Showcase
//
//  Created by Gustavo on 8/06/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        configureWindow()
    }
    
    func configureWindow() {
        window?.rootViewController = UINavigationController(rootViewController:
                                                                RedditFeedUIComposer.makeFeedViewController())
        
        window?.makeKeyAndVisible()
    }
}
