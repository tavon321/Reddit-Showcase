//
//  ReddiFeedPresentationAdapter.swift
//  Reddit-Showcase
//
//  Created by Gustavo on 11/06/21.
//

import Foundation

final class FeedLoaderPresentationAdapter: FeedViewControllerDelegate {
    private let redditFeedLoader: RedditTopFeedLoader
    
    var presenter: RedditFeedPresenter?
    
    init(redditFeedLoader: RedditTopFeedLoader) {
        self.redditFeedLoader = redditFeedLoader
    }
    
    func didRequestFeedRefresh(page: String) {
        presenter?.didStartLoading()
        
        redditFeedLoader.loadFeed(page: page) { [weak self] result in
            switch result {
            case .success(let feedList):
                self?.presenter?.didFinishLoading(with: feedList)
            case .failure(let error):
                self?.presenter?.didFinishLoading(with: error)
            }
        }
    }
}
