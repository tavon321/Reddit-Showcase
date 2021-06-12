//
//  URLSessionHttpClientTest.swift
//  Reddit-ShowcaseTests
//
//  Created by Gustavo on 9/06/21.
//

import XCTest
import Reddit_Showcase

class URLSessionHttpClientTest: XCTestCase {
    override func setUpWithError() throws {
        URLProtocolStub.startInterceptingRequest()
    }
    
    override func tearDownWithError() throws {
        URLProtocolStub.stopInterceptionRequest()
    }
    
    func test_loadFromURL_performRequestWithURL() {
        let url = anyURL
        let exp = expectation(description: "Wait for request")
        
        URLProtocolStub.observeRequest { request in
            XCTAssertEqual(request.url, url)
            XCTAssertEqual(request.httpMethod, "GET")
            exp.fulfill()
        }
        
        _ = makeSUT().load(url: url) { _ in }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_loadFromUrl_failsOnRequestError() {
        let requestedError = anyNSError
        let receivedError = resultErrorFor(data: nil, response: nil, error: requestedError)
        
        XCTAssertEqual(requestedError.code, (receivedError as NSError?)?.code)
        XCTAssertEqual(requestedError.domain, (receivedError as NSError?)?.domain)
    }
    
    func test_loadFromUrl_failsOnAllInvalidCasesValues() {
        XCTAssertNotNil(resultErrorFor(data: nil, response: nil, error: nil))
        XCTAssertNotNil(resultErrorFor(data: nil, response: nonHTTTPURLResponse, error: nil))
        XCTAssertNotNil(resultErrorFor(data: nil, response: anyHTTTPURLResponse, error: anyNSError))
        XCTAssertNotNil(resultErrorFor(data: anyData, response: nil, error: nil))
        XCTAssertNotNil(resultErrorFor(data: anyData, response: nil, error: anyNSError))
        XCTAssertNotNil(resultErrorFor(data: nil, response: nonHTTTPURLResponse, error: anyNSError))
        XCTAssertNotNil(resultErrorFor(data: nil, response: anyHTTTPURLResponse, error: anyNSError))
        XCTAssertNotNil(resultErrorFor(data: anyData, response: nonHTTTPURLResponse, error: anyNSError))
        XCTAssertNotNil(resultErrorFor(data: anyData, response: anyHTTTPURLResponse, error: anyNSError))
        XCTAssertNotNil(resultErrorFor(data: anyData, response: nonHTTTPURLResponse, error: nil))
    }
    
    func test_loadFromURL_succeedOnHTTPResponseWithData() {
        let expectedData = anyData
        let expectedHTTPResponse = anyHTTTPURLResponse
        let result = resultSucceedFor(data: expectedData, response: expectedHTTPResponse)
        
        XCTAssertEqual(expectedData, result?.data)
        XCTAssertEqual(expectedHTTPResponse.statusCode, result?.response.statusCode)
    }
    
    // MARK: - Helpers
    private var nonHTTTPURLResponse: URLResponse {
        return URLResponse(url: anyURL, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
    }
    
    private var anyHTTTPURLResponse: HTTPURLResponse {
        return HTTPURLResponse(url: anyURL, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
    }
    
    private func resultSucceedFor(data: Data?,
                                  response: URLResponse?,
                                  file: StaticString = #file,
                                  line: UInt = #line) -> (data: Data, response: HTTPURLResponse)? {
        let result = resultFor(data: data, response: response, error: nil, file: file, line: line)
        var capturedResponse: (data: Data, response: HTTPURLResponse)?
        
        switch result {
        case let.success((data, response)):
            capturedResponse = (data, response)
        default:
            XCTFail("Expected success, got \(result as Any) instead", file: file, line: line)
        }
        
        return capturedResponse
    }
    
    private func resultErrorFor(data: Data?, response: URLResponse?, error: Error?, file: StaticString = #file, line: UInt = #line) -> Error? {
        let result = resultFor(data: data, response: response, error: error, file: file, line: line)
        var capturedError: Error?
        
        switch result {
        case .failure(let receivedError):
            capturedError = receivedError
        default:
            XCTFail("Expected failure, got \(result as Any) instead", file: file, line: line)
        }
        
        return capturedError
    }
    
    private func resultFor(data: Data?, response: URLResponse?, error: Error?, file: StaticString = #file, line: UInt = #line) -> HTTPClient.Result? {
        URLProtocolStub.stub(data: data, response: response, error: error)
        let exp = expectation(description: "Wait for result")
        
        var capturedResult: HTTPClient.Result?
        _ = makeSUT().load(url: anyURL) { result in
            capturedResult = result
            exp.fulfill()
        }

        wait(for: [exp], timeout: 1)
        
        return capturedResult
    }
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> URLSessionHTTPClient {
        let sut = URLSessionHTTPClient()
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return sut
    }
    
    private class URLProtocolStub: URLProtocol {
        private static var stub: Stub?
        private static var requestObserver: ((URLRequest) -> Void)?
        
        static func startInterceptingRequest() {
            URLProtocol.registerClass(URLProtocolStub.self)
        }
        
        static func stopInterceptionRequest() {
            URLProtocol.unregisterClass(URLProtocolStub.self)
            stub = nil
            requestObserver = nil
        }
        
        private struct Stub {
            let data: Data?
            let response: URLResponse?
            let error: Error?
        }
        
        static func stub(data: Data?, response: URLResponse?, error: Error? = nil) {
            stub = Stub(data: data, response: response, error: error)
        }
        
        override class func canInit(with request: URLRequest) -> Bool {
            return true
        }
        
        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            return request
        }
        
        static func observeRequest(observer: @escaping (URLRequest) -> Void) {
            requestObserver = observer
        }
        
        override func startLoading() {
            if let requestObserver = URLProtocolStub.requestObserver {
                client?.urlProtocolDidFinishLoading(self)
                return requestObserver(request)
            }

            if let data = URLProtocolStub.stub?.data {
                client?.urlProtocol(self, didLoad: data)
            }
            
            if let response = URLProtocolStub.stub?.response {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            
            if let error = URLProtocolStub.stub?.error {
                client?.urlProtocol(self, didFailWithError: error)
            }
            
            client?.urlProtocolDidFinishLoading(self)
        }
        
        override func stopLoading() {}
    }
}
