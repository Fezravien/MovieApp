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
    
    enum Mode {
        case entire
        case favorite
    }
    
    private let movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let movieTitle: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let movieDirector: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let movieActor: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let movieRating: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let movieInformationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private let moviewListViewModel = MovieListViewModel()
    private var mode: Mode?
    weak var movieListDelegate: MovieListDelegate?
    weak var favoriteListDelegate: FavoriteListDelegate?
    
    func setMovieListCell(movieItem: MovieItem, favorite: [MovieItem]) {
        setConstraints()
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
        self.movieImageView.image = nil
        self.movieTitle.text = nil
        self.movieDirector.text = nil
        self.movieActor.text = nil
        self.movieRating.text = nil

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
                self.movieImageView.image = UIImage(data: movieImage)
                self.movieTitle.text = self.moviewListViewModel.convertTitle()
                self.movieDirector.text = self.moviewListViewModel.convertFormat(movieText: item.director, movieInformation: .diector)
                self.movieActor.text = self.moviewListViewModel.convertFormat(movieText: item.actor, movieInformation: .actor)
                self.movieRating.text = self.moviewListViewModel.convertFormat(movieText: item.userRating, movieInformation: .rating)
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
    
    private func setConstraints() {
        setMovieImageViewConstraint()
        setMovieInformationStackViewConstraint()
        self.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
    }
    
    
    private func setMovieImageViewConstraint() {
        self.contentView.addSubview(self.movieImageView)
        
        NSLayoutConstraint.activate([
            self.movieImageView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 1/5),
            self.movieImageView.heightAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 4/15),
            self.movieImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            self.movieImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8),
            self.movieImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8)
        ])
    }
    
    private func setMovieInformationStackViewConstraint() {
        self.contentView.addSubview(self.movieInformationStackView)
        self.movieInformationStackView.addArrangedSubview(self.movieTitle)
        self.movieInformationStackView.addArrangedSubview(self.movieDirector)
        self.movieInformationStackView.addArrangedSubview(self.movieActor)
        self.movieInformationStackView.addArrangedSubview(self.movieRating)
        
        NSLayoutConstraint.activate([
            self.movieInformationStackView.leadingAnchor.constraint(equalTo: self.movieImageView.trailingAnchor, constant: 8),
            self.movieInformationStackView.topAnchor.constraint(equalTo: self.movieImageView.topAnchor),
            self.movieInformationStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            self.movieInformationStackView.bottomAnchor.constraint(equalTo: self.movieImageView.bottomAnchor)
        ])
    }
}
