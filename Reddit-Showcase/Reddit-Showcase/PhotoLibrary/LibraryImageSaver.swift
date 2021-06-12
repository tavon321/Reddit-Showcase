//
//  LibraryImageSaver.swift
//  Reddit-Showcase
//
//  Created by Gustavo on 12/06/21.
//

import UIKit

public protocol PhotoLibrary {
    associatedtype Image
    typealias Result = Error?
    
    func save(_ image: Image, completion: @escaping (Result) -> Void)
}

public class LibraryImageSaver<Library: PhotoLibrary, Image>: ImageSaver where Library.Image == Image {
    private let photoLibrary: Library
    private let imageTransformer: (Data) -> Image?
    
    public typealias Result = ImageSaver.Result
    
    struct InvalidImageError: Error {}
    
    public init(photoLibrary: Library, imageTransformer: @escaping (Data) -> Image?) {
        self.photoLibrary = photoLibrary
        self.imageTransformer = imageTransformer
    }
    
    public func save(_ data: Data, completion: @escaping (Result) -> Void) {
        guard let image = imageTransformer(data) else {
            completion(InvalidImageError())
            return
        }
        
        photoLibrary.save(image) { error in
            completion(error)
        }
    }
}
