//
//  LibraryImageSaver.swift
//  Reddit-Showcase
//
//  Created by Gustavo on 12/06/21.
//

import UIKit

public protocol PhotoLibrary {
    typealias Result = Error?
    
    func save(_ image: UIImage, completion: @escaping (Result) -> Void)
}

public class LibraryImageSaver: ImageSaver {
   
    private let photoLibrary: PhotoLibrary
    
    public typealias Result = ImageSaver.Result
    
    public init(photoLibrary: PhotoLibrary) {
        self.photoLibrary = photoLibrary
    }
    
    public func save(_ image: UIImage, completion: @escaping (Result) -> Void) {
        photoLibrary.save(image) { error in
            completion(error)
        }
    }
}
