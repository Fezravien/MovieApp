//
//  MovieSession.swift
//  MovieApp
//
//  Created by Fezravien on 2021/11/01.
//

import Foundation

protocol MovieSession {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}
