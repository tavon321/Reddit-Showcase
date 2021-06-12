//
//  RedditFeedUIComposer.swift
//  Reddit-Showcase
//
//  Created by Gustavo on 10/06/21.
//

import UIKit

struct RedditFeedUIComposer {
    
    public static func compose(feedLoader: RedditTopFeedLoader,
                               imageLoader: ImageDataLoader) -> FeedViewController {
        let presentationAdapter = FeedLoaderPresentationAdapter(redditFeedLoader: feedLoader)
        let controller = makeFeedViewController(delegate: presentationAdapter)
        
        presentationAdapter.presenter = RedditFeedPresenter(view: controller,
                                                            listView: FeedViewAdapter(controller: controller,
                                                                                      imageLoader: imageLoader))
        return controller
    }
    
    private static func makeFeedViewController(delegate: FeedViewControllerDelegate) -> FeedViewController {
        let bundle = Bundle(for: FeedViewController.self)
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        let feedController = storyboard.instantiateInitialViewController() as! FeedViewController
        
        feedController.delegate = delegate
        feedController.title = "Reddit Top Feed"
        
        return feedController
    }
}
