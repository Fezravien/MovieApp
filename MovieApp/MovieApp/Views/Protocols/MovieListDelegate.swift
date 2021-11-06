//
//  MovieListDelegate.swift
//  MovieApp
//
//  Created by Fezravien on 2021/11/04.
//

import Foundation

protocol MovieListDelegate: AnyObject {
    func finishedFetch()
    func removeFavoriteItem(item: MovieItem)
    func addFavoriteItem(item: MovieItem)
    func favoriteRefresh()
}
