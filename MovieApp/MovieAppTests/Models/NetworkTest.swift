//
//  NetworkTest.swift
//  MovieAppTests
//
//  Created by Fezravien on 2021/11/02.
//

import XCTest
@testable import MovieApp

class NetworkTest: XCTestCase {
    var mockSession: MovieSession?

    override func setUpWithError() throws {
        self.mockSession = MockSession.urlSession
    }

    override func tearDownWithError() throws {
        self.mockSession = nil
    }
    
    func test_isError_Network_Fail() {
        // given
        let url = NetworkConstant.get(0, "").url!
        let mockNetwork = Network(session: self.mockSession!)
        MockURLProtocol.error = MovieError.network
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: url,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: ["Content-Type": "application/json"])!
            
            return (response, Data())
        }
        
        // when
        let expectation = XCTestExpectation(description: "Response have network error")
        mockNetwork.excuteNetwork(request: URLRequest(url: url)) { result in
            defer { expectation.fulfill() }
            // then
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                guard let error = error as? MovieError else {
                    XCTFail()
                    return
                }
                
                XCTAssertEqual(MovieError.network.descripion, error.descripion)
            }
        }
        wait(for: [expectation], timeout: 3)
    }
    
    func test_Network_HTTPStatusCodeNot200_fail() {
        // given
        let url = NetworkConstant.get(0, "").url!
        let mockNetwork = Network(session: self.mockSession!)
        MockURLProtocol.error = nil
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: url,
                                           statusCode: 400,
                                           httpVersion: nil,
                                           headerFields: ["Content-Type": "application/json"])!
            
            return (response, Data())
        }
        
        // when
        let expectation = XCTestExpectation(description: "Response have network error")
        mockNetwork.excuteNetwork(request: URLRequest(url: url)) { result in
            defer { expectation.fulfill() }
            // then
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                guard let error = error as? MovieError else {
                    XCTFail()
                    return
                }
                
                XCTAssertEqual(MovieError.response(400).descripion, error.descripion)
            }
        }
        wait(for: [expectation], timeout: 3)
    }
    
    func test_Network_Succeed() {
        // given
        let url = NetworkConstant.get(0, "").url!
        let mockNetwork = Network(session: self.mockSession!)
        MockURLProtocol.error = nil
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: url,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: ["Content-Type": "application/json"])!
            
            return (response, Data())
        }
        
        // when
        let expectation = XCTestExpectation(description: "Response Succeed")
        mockNetwork.excuteNetwork(request: URLRequest(url: url)) { result in
            defer { expectation.fulfill() }
            // then
            switch result {
            case .success(_):
                XCTAssert(true)
            case .failure(_):
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: 3)
    }

}
