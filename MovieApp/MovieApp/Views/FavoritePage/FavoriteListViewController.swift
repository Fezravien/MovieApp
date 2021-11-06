//
//  FavoriteListViewController.swift
//  MovieApp
//
//  Created by Fezravien on 2021/11/05.
//

import UIKit

final class FavoriteListViewController: UIViewController {
    private let favoriteTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MovieListCell.self, forCellReuseIdentifier: MovieListCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    private let indicater: UIActivityIndicatorView = {
        let indicater = UIActivityIndicatorView()
        indicater.hidesWhenStopped = true
        indicater.style = .large
        indicater.translatesAutoresizingMaskIntoConstraints = false
        return indicater
    }()
    private let favoriteListViewModel = MovieListViewModel()
    private var removeIndexPath: IndexPath?
    weak var movieListDelegate: MovieListDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setConstraints()
        setDataSource()
        setDelegate()
        bindData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.movieListDelegate?.favoriteRefresh()
    }
    
    func setFavorite(favoriteList: [MovieItem]) {
        self.favoriteListViewModel.addFavoriteItems(items: favoriteList)
        self.navigationItem.title = "즐겨찾기 목록"
    }
    
    private func bindData() {
        self.favoriteListViewModel.bindMovieFavoriteList {
            DispatchQueue.main.async { [unowned self] in
                guard let indexPath = self.removeIndexPath else { return }
                
                self.favoriteTableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    
    private func setDataSource() {
        self.favoriteTableView.dataSource = self
    }
    
    private func setDelegate() {
        self.favoriteTableView.delegate = self
    }
    
    private func setConstraints() {
        setFavoriteTableViewConstraint()
    }

    private func setFavoriteTableViewConstraint() {
        self.view.addSubview(self.favoriteTableView)
        
        NSLayoutConstraint.activate([
            self.favoriteTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.favoriteTableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.favoriteTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.favoriteTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    private func setIndicaterConstraint() {
        self.view.addSubview(self.indicater)
        
        NSLayoutConstraint.activate([
            self.indicater.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.indicater.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
}

extension FavoriteListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.favoriteListViewModel.movieFavoriteList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieListCell.identifier, for: indexPath) as? MovieListCell,
              let favoriteMovieItem = self.favoriteListViewModel.movieFavoriteList?[indexPath.row] else { return UITableViewCell() }
        
        cell.favoriteListDelegate = self
        cell.setMovieListCell(movieItem: favoriteMovieItem, favorite: self.favoriteListViewModel.movieFavoriteList ?? [])
        
        return cell
    }
}

extension FavoriteListViewController: UITableViewDelegate {
    
}

extension FavoriteListViewController: FavoriteListDelegate {
    func finishedFetch() {
        DispatchQueue.main.async {
            self.indicater.stopAnimating()
        }
    }
    
    func removeFavoriteItem(item: MovieItem) {
        self.removeIndexPath = self.favoriteListViewModel.indexPathForRemoveItem(item: item)
        self.favoriteListViewModel.removeFavoriteItem(item: item)
        self.movieListDelegate?.removeFavoriteItem(item: item)
    }
    
    func addFavoriteItem(item: MovieItem) {
//        self.favoriteListViewModel.addFavoriteItem(item: item)
//        self.movieListDelegate?.addFavoriteItem(item: item)
    }
}
