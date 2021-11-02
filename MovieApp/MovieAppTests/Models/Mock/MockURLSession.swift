//
//  MockURLSession.swift
//  MovieAppTests
//
//  Created by Fezravien on 2021/11/02.
//

import Foundation

struct MockSession {
    static var urlSession: URLSession {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        return URLSession(configuration: configuration)
    }
}
