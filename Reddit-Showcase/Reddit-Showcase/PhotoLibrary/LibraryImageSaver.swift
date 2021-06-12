//
//  LibraryImageSaver.swift
//  Reddit-Showcase
//
//  Created by Gustavo on 12/06/21.
//

import UIKit

public protocol PhotoLibrary {
    
    func save(_ image: UIImage)
}

public class LibraryImageSaver: NSObject {
    private let photoLibrary: PhotoLibrary
    
    public init(photoLibrary: PhotoLibrary) {
        self.photoLibrary = photoLibrary
    }
    
    public func save(_ image: UIImage) {
        photoLibrary.save(image)
    }
}
