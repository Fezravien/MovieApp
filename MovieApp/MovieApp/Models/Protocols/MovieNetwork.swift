//
//  MovieNetwork.swift
//  MovieApp
//
//  Created by Fezravien on 2021/11/01.
//

import Foundation

protocol MovieNetwork {
    func excuteNetwork(request: URLRequest, completion: @escaping (Result<Data, Error>) -> ())
}
