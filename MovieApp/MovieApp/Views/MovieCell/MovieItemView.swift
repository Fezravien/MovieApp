//
//  MovieItemView.swift
//  MovieApp
//
//  Created by Fezravien on 2021/11/06.
//

import UIKit

final class MovieItemView: UIView {
    let movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    let movieTitle: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let movieDirector: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let movieActor: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let movieRating: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let movieInformationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setConstraints()
    }
    
    private func setConstraints() {
        setMovieImageViewConstraint()
        setMovieInformationStackViewConstraint()
    }
    
    
    private func setMovieImageViewConstraint() {
        self.addSubview(self.movieImageView)
        
        NSLayoutConstraint.activate([
            self.movieImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/5),
            self.movieImageView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 4/15),
            self.movieImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            self.movieImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            self.movieImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8)
        ])
    }
    
    private func setMovieInformationStackViewConstraint() {
        self.addSubview(self.movieInformationStackView)
        self.movieInformationStackView.addArrangedSubview(self.movieTitle)
        self.movieInformationStackView.addArrangedSubview(self.movieDirector)
        self.movieInformationStackView.addArrangedSubview(self.movieActor)
        self.movieInformationStackView.addArrangedSubview(self.movieRating)
        
        NSLayoutConstraint.activate([
            self.movieInformationStackView.leadingAnchor.constraint(equalTo: self.movieImageView.trailingAnchor, constant: 8),
            self.movieInformationStackView.topAnchor.constraint(equalTo: self.movieImageView.topAnchor),
            self.movieInformationStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            self.movieInformationStackView.bottomAnchor.constraint(equalTo: self.movieImageView.bottomAnchor)
        ])
    }
}
