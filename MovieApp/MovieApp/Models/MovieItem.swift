//
//  MovieItem.swift
//  MovieApp
//
//  Created by Fezravien on 2021/11/01.
//

import Foundation

struct MovieItem: Decodable {
    let title: String
    let link: String
    let image: String
    let subtitle: String
    let pubDate: String
    let director: String
    let actor: String
    let userRation: String
}
