//
//  NetworkManagerTest.swift
//  MovieAppTests
//
//  Created by Fezravien on 2021/11/02.
//

import XCTest
@testable import MovieApp

class MovieAppTests: XCTestCase {
    var networkManager: NetworkManager?
    var mockNetworkManager: NetworkManager?
    var mockNetwork: Network?
    
    override func setUpWithError() throws {
        self.networkManager = NetworkManager(networkLoader: Network(session: URLSession.shared), decoder: JSONDecoder())
        self.mockNetwork = Network(session: MockSession.urlSession)
        self.mockNetworkManager = NetworkManager(networkLoader: self.mockNetwork!, decoder: JSONDecoder())
    }

    override func tearDownWithError() throws {
        self.networkManager = nil
        self.mockNetwork = nil
        self.mockNetworkManager = nil
    }
    
    func test_네트워크_유관_테스트() {
        // given
        let expectation = XCTestExpectation(description: "영화 정보 검색")
        guard let request = self.networkManager?.createRequest(page: 0, search: "어벤져스") else {
            XCTFail()
            return
        }
        
        // when
        self.networkManager?.fetch(request: request, completion: { result in
            defer { expectation.fulfill() }
            switch result {
                // then
            case .success(let data):
                XCTAssertNotEqual(0, data.items.count)
            case .failure(_):
                XCTFail()
            }
            
        })
        
        wait(for: [expectation], timeout: 5)
    }
    
    func test_네트워크_무관_테스트() {
        // given
        MockURLProtocol.error = nil
        MockURLProtocol.requestHandler = { _ in
            let response = HTTPURLResponse(url: NetworkConstant.get(0, "").url!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: ["Content-Type": "application/json"])!
            
            return (response, Data())
        }
        let request = networkManager!.createRequest(page: 0, search: "")!
        
        // when
        networkManager?.fetch(request: request, completion: { result in
            // then
            switch result {
            case .success(_):
                XCTAssert(true)
            case .failure(_):
                XCTFail()
            }
        })
    }
}
