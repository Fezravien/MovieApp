//
//  MovieListCell.swift
//  MovieApp
//
//  Created by Fezravien on 2021/11/02.
//

import UIKit

final class MovieListCell: UITableViewCell {
    static let identifier = "MovieListCell"
    
    enum Favorite {
        case yes
        case no
    }
    
    private let movieItemView = MovieItemView()
    private let moviewListViewModel = MovieListViewModel()
    weak var movieListDelegate: MovieListDelegate?
    weak var favoriteListDelegate: FavoriteListDelegate?
    
    func setMovieListCell(movieItem: MovieItem, favorite: [MovieItem]) {
//        setConstraints()
        setMovieItemViewConstraint()
        bindData()
        setFavorite(movieItem: movieItem, favorite: favorite)
        registeAccessoryViewGestureRecognizer()
        self.selectionStyle = .none
        self.moviewListViewModel.setItem(movieItem: movieItem)
        self.moviewListViewModel.downloadImage(movieItem.image)
    }
    
    private func setFavorite(movieItem: MovieItem, favorite: [MovieItem]) {
        self.moviewListViewModel.addFavoriteItems(items: favorite)
        if favorite.contains(movieItem) {
            self.moviewListViewModel.toggleFavortie(favorite: true)
        } else {
            self.moviewListViewModel.toggleFavortie(favorite: false)
        }
    }
    
    private func registeAccessoryViewGestureRecognizer() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedAccessoryView))
        self.accessoryView?.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc private func tappedAccessoryView() {
        guard let item = self.moviewListViewModel.movieItem else { return }
        let isfavorite = self.moviewListViewModel.movieFavorite
        
        if isfavorite {
            self.moviewListViewModel.toggleFavortie(favorite: false)
            self.moviewListViewModel.removeFavoriteItem(item: item)
            self.movieListDelegate?.removeFavoriteItem(item: item)
            self.favoriteListDelegate?.removeFavoriteItem(item: item)
        } else {
            self.moviewListViewModel.toggleFavortie(favorite: true)
            self.moviewListViewModel.addFavoriteItem(item: item)
            self.movieListDelegate?.addFavoriteItem(item: item)
            self.favoriteListDelegate?.addFavoriteItem(item: item)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        setAccessoryView(favorite: .no)
        self.movieItemView.movieImageView.image = nil
        self.movieItemView.movieTitle.text = nil
        self.movieItemView.movieDirector.text = nil
        self.movieItemView.movieActor.text = nil
        self.movieItemView.movieRating.text = nil

    }
    
    private func setAccessoryView(favorite: Favorite) {
        switch favorite {
        case .yes:
            let accessory = UIImageView(image: UIImage(systemName: "star.fill"))
            accessory.tintColor = .systemOrange
            accessory.isUserInteractionEnabled = true
            self.accessoryView = accessory
        case .no:
            let accessory = UIImageView(image: UIImage(systemName: "star"))
            accessory.tintColor = .systemOrange
            accessory.isUserInteractionEnabled = true
            self.accessoryView = accessory
        }
        registeAccessoryViewGestureRecognizer()
    }

    private func bindData() {
        self.moviewListViewModel.bindItemImage {
            self.movieListDelegate?.finishedFetch()
            guard let movieImage = self.moviewListViewModel.movieImage,
                  let item = self.moviewListViewModel.movieItem else {
                      
                      return
                  }
            
            DispatchQueue.main.async {
                self.movieItemView.movieImageView.image = UIImage(data: movieImage)
                self.movieItemView.movieTitle.text = self.moviewListViewModel.convertTitle()
                self.movieItemView.movieDirector.text = self.moviewListViewModel.convertFormat(movieText: item.director, movieInformation: .diector)
                self.movieItemView.movieActor.text = self.moviewListViewModel.convertFormat(movieText: item.actor, movieInformation: .actor)
                self.movieItemView.movieRating.text = self.moviewListViewModel.convertFormat(movieText: item.userRating, movieInformation: .rating)
            }
        }
        
        self.moviewListViewModel.bindMovieFavorite {
            if self.moviewListViewModel.movieFavorite {
                self.setAccessoryView(favorite: .yes)
            } else {
                self.setAccessoryView(favorite: .no)
            }
        }
        
        self.moviewListViewModel.bindMovieFavoriteList {
            if self.moviewListViewModel.movieFavorite {
                self.setAccessoryView(favorite: .yes)
            } else {
                self.setAccessoryView(favorite: .no)
            }
        }
    }
    
    private func setMovieItemViewConstraint() {
        self.contentView.addSubview(self.movieItemView)
        self.movieItemView.frame = CGRect(x: 0, y: 0, width: self.contentView.frame.width, height: self.contentView.frame.width * 4/15 + 16)
        
        NSLayoutConstraint.activate([
            self.movieItemView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.movieItemView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.movieItemView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.movieItemView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
    }
}
