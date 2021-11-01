//
//  MovieItemList.swift
//  MovieApp
//
//  Created by Fezravien on 2021/11/01.
//

import Foundation

struct MovieItemList: Decodable {
    let lastBuildData: String
    let total: Int
    let start: Int
    let display: Int
    let items: [MovieItem]
}
