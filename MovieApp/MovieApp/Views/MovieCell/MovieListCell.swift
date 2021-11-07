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
    
    private let movieItemView: MovieItemView = {
        let view = MovieItemView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let movieListViewModel = MovieListViewModel()
    weak var movieListDelegate: MovieListDelegate?
    weak var favoriteListDelegate: FavoriteListDelegate?
    
    func setMovieListCell(movieItem: MovieItem, favorite: [MovieItem]) {
        setMovieItemViewConstraint()
        bindData()
        setFavorite(movieItem: movieItem, favorite: favorite)
        registeAccessoryViewGestureRecognizer()
        self.selectionStyle = .none
        self.movieListViewModel.setItem(movieItem: movieItem)
        self.movieListViewModel.downloadImage(movieItem.image)
    }
    
    private func setFavorite(movieItem: MovieItem, favorite: [MovieItem]) {
        self.movieListViewModel.addFavoriteItems(items: favorite)
        if favorite.contains(movieItem) {
            self.movieListViewModel.toggleFavortie(favorite: true)
        } else {
            self.movieListViewModel.toggleFavortie(favorite: false)
        }
    }
    
    private func registeAccessoryViewGestureRecognizer() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedAccessoryView))
        self.accessoryView?.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc private func tappedAccessoryView() {
        guard let item = self.movieListViewModel.movieItem else { return }
        let isfavorite = self.movieListViewModel.movieFavorite
        
        if isfavorite {
            self.movieListViewModel.toggleFavortie(favorite: false)
            self.movieListViewModel.removeFavoriteItem(item: item)
            self.movieListDelegate?.removeFavoriteItem(item: item)
            self.favoriteListDelegate?.removeFavoriteItem(item: item)
        } else {
            self.movieListViewModel.toggleFavortie(favorite: true)
            self.movieListViewModel.addFavoriteItem(item: item)
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
        self.movieListViewModel.bindItemImage {
            self.movieListDelegate?.finishedFetch()
            guard let movieImage = self.movieListViewModel.movieImage,
                  let item = self.movieListViewModel.movieItem else {
                      
                      return
                  }
            
            DispatchQueue.main.async {
                self.movieItemView.movieImageView.image = UIImage(data: movieImage)
                self.movieItemView.movieTitle.text = self.movieListViewModel.convertTitle()
                self.movieItemView.movieDirector.text = self.movieListViewModel.convertFormat(movieText: item.director, movieInformation: .diector)
                self.movieItemView.movieActor.text = self.movieListViewModel.convertFormat(movieText: item.actor, movieInformation: .actor)
                self.movieItemView.movieRating.text = self.movieListViewModel.convertFormat(movieText: item.userRating, movieInformation: .rating)
            }
        }
        
        self.movieListViewModel.bindMovieFavorite {
            if self.movieListViewModel.movieFavorite {
                self.setAccessoryView(favorite: .yes)
            } else {
                self.setAccessoryView(favorite: .no)
            }
        }
        
        self.movieListViewModel.bindMovieFavoriteList {
            if self.movieListViewModel.movieFavorite {
                self.setAccessoryView(favorite: .yes)
            } else {
                self.setAccessoryView(favorite: .no)
            }
        }
    }
    
    private func setMovieItemViewConstraint() {
        self.contentView.addSubview(self.movieItemView)

        NSLayoutConstraint.activate([
            self.movieItemView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.movieItemView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.movieItemView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.movieItemView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
    }
}
