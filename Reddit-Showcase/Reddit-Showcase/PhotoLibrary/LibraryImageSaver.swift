//
//  LibraryImageSaver.swift
//  Reddit-Showcase
//
//  Created by Gustavo on 12/06/21.
//

import UIKit

public protocol PhotoLibrary {
    
}

public class LibraryImageSaver: NSObject {
    private let photoLibrary: PhotoLibrary
    
    public init(photoLibrary: PhotoLibrary) {
        self.photoLibrary = photoLibrary
    }
}
