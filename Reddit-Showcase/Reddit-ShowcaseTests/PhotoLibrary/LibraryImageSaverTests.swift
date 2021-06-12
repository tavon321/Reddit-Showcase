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
        let expectedImage = AnyImage()
        let (sut, library) = makeSUT(imageTransformer: { _ in expectedImage })
       
        sut.save(anyData) { _ in }
        XCTAssertEqual(library.images, [expectedImage])
    }
    
    func test_save_deliversInavlidImageErrorOnInvalidDataTransform ()  {
        let (sut, _) = makeSUT(imageTransformer: { _ in nil })
        
        var capturedError: Error?
        sut.save(anyData) { error in
            capturedError = error
        }
        
        XCTAssertEqual(capturedError as NSError?,
                       LibraryImageSaver<PhotoLibrarySpy, AnyImage>.InvalidImageError() as NSError)
    }
    
    func test_save_deliversErrorOnSaveError() {
        let (sut, library) = makeSUT(imageTransformer: { _ in AnyImage() })
        
        var capturedError: Error?
        sut.save(anyData) { error in
            capturedError = error
        }
        
        library.completeSucessfully()
        XCTAssertNil(capturedError)
    }
    
    func test_save_doesNotDeliversErrorOnSaveError() {
        let (sut, library) = makeSUT(imageTransformer: { _ in AnyImage() })
        let expectedError = anyNSError
        
        var capturedError: Error?
        sut.save(anyData) { error in
            capturedError = error
        }
        
        library.complete(with: expectedError)
        XCTAssertEqual(capturedError as NSError?, expectedError)
    }
    
    // MARK: - Helpers
    private struct AnyImage: Equatable {}
    
    private func makeSUT(imageTransformer: @escaping (Data) -> AnyImage? = { _ in nil },
                         file: StaticString = #file,
                         line: UInt = #line)
    -> (sut: LibraryImageSaver<PhotoLibrarySpy, AnyImage>, library: PhotoLibrarySpy) {
        let library = PhotoLibrarySpy()
        let sut = LibraryImageSaver(photoLibrary: library, imageTransformer: imageTransformer)
        
        trackForMemoryLeaks(library, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut: sut, library: library)
    }
    
    
    private class PhotoLibrarySpy: PhotoLibrary {
        private(set) var messages = [(image: AnyImage, completion: (PhotoLibrary.Result) -> Void)]()
        var images: [AnyImage] { messages.map({ $0.image }) }
        
        func save(_ image: AnyImage, completion: @escaping (PhotoLibrary.Result) -> Void) {
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
