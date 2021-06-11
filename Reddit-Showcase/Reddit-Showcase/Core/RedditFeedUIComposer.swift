//
//  RedditFeedUIComposer.swift
//  Reddit-Showcase
//
//  Created by Gustavo on 10/06/21.
//

import UIKit

struct RedditFeedUIComposer {
    
    static func makeFeedViewController() -> FeedViewController {
        let bundle = Bundle(for: FeedViewController.self)
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        let feedController = storyboard.instantiateInitialViewController() as! FeedViewController
        return feedController
    }
}
