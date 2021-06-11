//
//  FeedImageViewModel.swift
//  Reddit-Showcase
//
//  Created by Gustavo on 10/06/21.
//

import Foundation

public struct FeedImageViewModel<Image> {
    public let title: String
    public let author: String
    public let elapsedInterval: String
    public let numberOfComments: String
    public let imageURL: URL?
    public let thumbnail: Image?
    public let isLoading: Bool
}
