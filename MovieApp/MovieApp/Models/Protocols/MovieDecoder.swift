//
//  MovieDecoder.swift
//  MovieApp
//
//  Created by Fezravien on 2021/11/01.
//

import Foundation

protocol MovieDecoder {
    func decode<T>(_ type: T.Type, from: Data) throws -> T where T : Decodable
}
