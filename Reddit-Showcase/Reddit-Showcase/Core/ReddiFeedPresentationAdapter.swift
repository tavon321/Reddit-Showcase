//
//  ReddiFeedPresentationAdapter.swift
//  Reddit-Showcase
//
//  Created by Gustavo on 11/06/21.
//

import Foundation

final class FeedLoaderPresentationAdapter: FeedViewControllerDelegate {
    private let cache = NSCache<NSString, NSData>()
    
    func didRequestFeedRefresh(page: String) {
        
    }
}
