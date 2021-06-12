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
        
        XCTAssertEqual(library.messages, 0)
    }
    
    // MARK: - Helpers
    private func makeSUT() -> (sut: LibraryImageSaver, library: PhotoLibrarySpy) {
        let library = PhotoLibrarySpy()
        let sut = LibraryImageSaver(photoLibrary: library)
        
        return (sut: sut, library: library)
    }
    
    
    private class PhotoLibrarySpy: PhotoLibrary {
        private(set) var messages = 0
    }
}
