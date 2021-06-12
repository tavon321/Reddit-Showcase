//
//  LibraryImageSaverTests.swift
//  Reddit-ShowcaseTests
//
//  Created by Gustavo on 12/06/21.
//

import XCTest
import Reddit_Showcase

class LibraryImageSaverTests: XCTest {
    
    func test_init_doesNoMessagePhotoLibrary() {
        let (_, library) = makeSUT()
        
        XCTAssertEqual(library.messages.count, 0)
    }
    
    func test_save_messageLibraryWithImage() {
        let (sut, library) = makeSUT()
        let expectedImage = anyImage
        
        sut.save(expectedImage)
        XCTAssertEqual(library.messages, [expectedImage])
    }
    
    // MARK: - Helpers
    private var anyImage: UIImage {  UIImage() }
    
    private func makeSUT() -> (sut: LibraryImageSaver, library: PhotoLibrarySpy) {
        let library = PhotoLibrarySpy()
        let sut = LibraryImageSaver(photoLibrary: library)
        
        return (sut: sut, library: library)
    }
    
    
    private class PhotoLibrarySpy: PhotoLibrary {
        private(set) var messages = [UIImage]()
        
        func save(_ image: UIImage) {
            messages.append(image)
        }
    }
}
