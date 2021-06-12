//
//  LibraryImageSaverTests.swift
//  Reddit-ShowcaseTests
//
//  Created by Gustavo on 12/06/21.
//

import XCTest
import Reddit_Showcase

class LibraryImageSaverTests: XCTestCase {
    
    func test_init_doesNoMessagePhotoLibrary() {
        let (_, library) = makeSUT()
        
        XCTAssertEqual(library.messages.count, 0)
    }
    
    func test_save_messageLibraryWithImage() {
        let (sut, library) = makeSUT()
        let expectedImage = anyImage
        
        sut.save(expectedImage) { _ in }
        XCTAssertEqual(library.images, [expectedImage])
    }
    
    func test_save_deliversErrorOnSaveError() {
        let (sut, library) = makeSUT()
        
        var capturedError: Error?
        sut.save(anyImage) { error in
            capturedError = error
        }
        
        library.completeSucessfully()
        XCTAssertNil(capturedError)
    }
    
    func test_save_doesNotDeliversErrorOnSaveError() {
        let (sut, library) = makeSUT()
        let expectedError = anyNSError
        
        var capturedError: Error?
        sut.save(anyImage) { error in
            capturedError = error
        }
        
        library.complete(with: expectedError)
        XCTAssertEqual(capturedError as NSError?, expectedError)
    }
    
    // MARK: - Helpers
    private var anyImage: UIImage {  UIImage() }
    
    private func makeSUT(file: StaticString = #file,
                         line: UInt = #line) -> (sut: LibraryImageSaver, library: PhotoLibrarySpy) {
        let library = PhotoLibrarySpy()
        let sut = LibraryImageSaver(photoLibrary: library)
        
        trackForMemoryLeaks(library, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut: sut, library: library)
    }
    
    
    private class PhotoLibrarySpy: PhotoLibrary {
        private(set) var messages = [(image: UIImage, completion: (PhotoLibrary.Result) -> Void)]()
        var images: [UIImage] { messages.map({ $0.image }) }
        
        func save(_ image: UIImage, completion: @escaping (PhotoLibrary.Result) -> Void) {
            messages.append((image, completion: completion))
        }
        
        func complete(with error: Error?, at index: Int = 0) {
            messages[index].completion(error)
        }
        
        func completeSucessfully(at index: Int = 0) {
            messages[index].completion(nil)
        }
    }
}
