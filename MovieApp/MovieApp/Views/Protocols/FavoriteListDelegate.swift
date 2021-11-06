//
//  FavoriteListDelegate.swift
//  MovieApp
//
//  Created by Fezravien on 2021/11/06.
//

import Foundation

protocol FavoriteListDelegate: AnyObject {
    func addFavoriteItem(item: MovieItem)
    func removeFavoriteItem(item: MovieItem)
}
