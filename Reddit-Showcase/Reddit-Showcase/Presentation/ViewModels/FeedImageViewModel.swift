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
    private let entryDate: TimeInterval
    public let numberOfComments: String
    public let imageURL: URL?
    public let thumbnail: Image?
    public let isLoading: Bool
    
    public var elapsedInterval: String {
        Date(timeIntervalSince1970: entryDate).getElapsedInterval()
    }
    
    public init(title: String,
                author: String,
                entryDate: TimeInterval,
                numberOfComments: String,
                imageURL: URL?,
                thumbnail: Image?,
                isLoading: Bool) {
        self.title = title
        self.author = author
        self.entryDate = entryDate
        self.numberOfComments = numberOfComments
        self.imageURL = imageURL
        self.thumbnail = thumbnail
        self.isLoading = isLoading
    }
}
