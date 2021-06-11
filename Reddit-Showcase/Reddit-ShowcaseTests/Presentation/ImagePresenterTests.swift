//
//  ImagePresenterTests.swift
//  Reddit-ShowcaseTests
//
//  Created by Gustavo on 10/06/21.
//

import XCTest

public protocol ImagePresenterView {
    
}

public class ImagePresenter {
    private let view: ImagePresenterView
    
    public init(view: ImagePresenterView) {
        self.view = view
    }
}

class ImagePresenterTests: XCTestCase {
    func test_init_doesNotMessageView() {
        let (_, view) = makeSUT()
        
        XCTAssertEqual(view.messages, 0)
    }
    
    // MARK: Helpers
    private func makeSUT(file: StaticString = #file,
                         line: UInt = #line) -> (sut: ImagePresenter, view: ImagePresenterViewSpy) {
        let view = ImagePresenterViewSpy()
        let sut = ImagePresenter(view: view)
        
        trackForMemoryLeaks(view, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, view)
    }
    
    private class ImagePresenterViewSpy: ImagePresenterView {
        private(set) var messages = 0
    }
}
