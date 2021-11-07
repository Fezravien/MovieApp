//
//  MovieDetailViewController.swift
//  MovieApp
//
//  Created by Fezravien on 2021/11/06.
//

import UIKit
import WebKit

final class MovieDetailViewController: UIViewController {
    
    enum Favorite {
        case yes
        case no
    }

    private let movieWebView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    private let indicater: UIActivityIndicatorView = {
        let indicater = UIActivityIndicatorView()
        indicater.hidesWhenStopped = true
        indicater.style = .large
        indicater.translatesAutoresizingMaskIntoConstraints = false
        return indicater
    }()
    private let movieDetailViewModel = MovieListViewModel()
    weak var movieListDelegate: MovieListDelegate?
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = self.movieDetailViewModel.convertTitle()
        self.view.backgroundColor = .white
        setConstraints()
        setDelegate()
        excuteMoiveWeb()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.movieListDelegate?.favoriteRefresh()
    }
    
    // MARK: - Main page to Detail page 설정

    func setDetailViewController(item: MovieItem, favorite: [MovieItem]) {
        bindData()
        setFavorite(movieItem: item, favorite: favorite)
        self.movieDetailViewModel.setItem(movieItem: item)
    }
    
    // MARK: - MovieDetailViewController 설정
    
    private func setDelegate() {
        self.movieWebView.navigationDelegate = self
    }
    
    private func setFavorite(movieItem: MovieItem, favorite: [MovieItem]) {
        self.movieDetailViewModel.addFavoriteItems(items: favorite)
        if favorite.contains(movieItem) {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "star.fill"),
                                                                     style: .plain,
                                                                     target: self,
                                                                     action: #selector(tappedYesFavoriteButton))
        } else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "star"),
                                                                     style: .plain,
                                                                     target: self,
                                                                     action: #selector(tappedNoFavoriteButton))
        }
        self.navigationItem.rightBarButtonItem?.tintColor = .systemOrange
    }
    
    private func setNavigationBarButtonItem(favorite: Favorite) {
        switch favorite {
        case .yes:
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "star.fill"),
                                                                     style: .plain,
                                                                     target: self,
                                                                     action: #selector(tappedYesFavoriteButton))
        case .no:
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "star"),
                                                                     style: .plain,
                                                                     target: self,
                                                                     action: #selector(tappedNoFavoriteButton))
        }
        self.navigationItem.rightBarButtonItem?.tintColor = .systemOrange
    }
    
    @objc private func tappedYesFavoriteButton() {
        guard let item = self.movieDetailViewModel.movieItem else { return }
        self.movieListDelegate?.removeFavoriteItem(item: item)
        self.movieDetailViewModel.toggleFavortie(favorite: false)
    }
    
    @objc private func tappedNoFavoriteButton() {
        guard let item = self.movieDetailViewModel.movieItem else { return }
        self.movieListDelegate?.addFavoriteItem(item: item)
        self.movieDetailViewModel.toggleFavortie(favorite: true)
    }
    
    // MARK: - MoviewListViewModel과 Data Binding
    
    private func bindData() {
        self.movieDetailViewModel.bindMovieFavorite {
            if self.movieDetailViewModel.movieFavorite {
                self.setNavigationBarButtonItem(favorite: .yes)
            } else {
                self.setNavigationBarButtonItem(favorite: .no)
            }
        }
    }
    
    // MARK: - WebView
    
    private func excuteMoiveWeb() {
        guard let item = self.movieDetailViewModel.movieItem,
              let url = URL(string: item.link) else {
                  
                  return
              }
        let request = URLRequest(url: url)
        self.movieWebView.load(request)
    }
    
    // MARK: - Constraints

    private func setConstraints() {
        setMovieWebViewConstraint()
        setIndicaterConstraint()
    }
    
    private func setMovieWebViewConstraint() {
        self.view.addSubview(self.movieWebView)
        
        NSLayoutConstraint.activate([
            self.movieWebView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.movieWebView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.movieWebView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.movieWebView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.movieWebView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            self.movieWebView.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor)
        ])
    }
    
    private func setIndicaterConstraint() {
        self.movieWebView.addSubview(self.indicater)
        
        NSLayoutConstraint.activate([
            self.indicater.centerXAnchor.constraint(equalTo: self.movieWebView.centerXAnchor),
            self.indicater.centerYAnchor.constraint(equalTo: self.movieWebView.centerYAnchor)
        ])
    }
}

// MARK: - WebView Delegate (WKNavigationDelegate)

extension MovieDetailViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.indicater.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.indicater.stopAnimating()
    }
}
