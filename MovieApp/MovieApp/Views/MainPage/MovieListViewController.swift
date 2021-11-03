//
//  MovieListViewController.swift
//  MovieApp
//
//  Created by Fezravien on 2021/11/01.
//

import UIKit

class MovieListViewController: UIViewController {
    private let movieTableView: UITableView = {
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
    private let searchController: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.searchBar.placeholder = "영화제목을 입력해주세요."
        return search
    }()
    private let movieListViewModel = MovieListViewModel()
    private var page = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setNaviation()
        setConstraints()
        bindData()
        fetchMovieItem()
        setMovieTableView()
    }
    
    private func setMovieTableView() {
        self.movieTableView.dataSource = self
        self.movieTableView.delegate = self
    }
    
    private func setNaviation() {
        self.navigationItem.searchController = searchController
        self.navigationItem.searchController?.obscuresBackgroundDuringPresentation = true
        self.navigationItem.title = "네이버 영화 검색"
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.backgroundColor = .white
    }
    
    private func bindData() {
        self.movieListViewModel.bindItemListFetch { [unowned self] in
            DispatchQueue.main.async {
                self.movieTableView.reloadData()
            }
        }
    }
    
    private func fetchMovieItem() {
        self.movieListViewModel.fetch(page: self.page, search: "사랑") { error in
            guard let _ = error else { return }
        }
    }
    
    private func setConstraints() {
        setMovieTableViewConstraint()
        setIndicaterConstraint()
    }
    
    private func setMovieTableViewConstraint() {
        self.view.addSubview(self.movieTableView)
        
        NSLayoutConstraint.activate([
            self.movieTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.movieTableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.movieTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.movieTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
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

extension MovieListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movieListViewModel.movieItemList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieListCell.identifier, for: indexPath) as? MovieListCell,
              let movieItem = self.movieListViewModel.movieItemList?[indexPath.row] else {
            return UITableViewCell()
        }
        cell.setMovieListCell(movieItem: movieItem, indexPath: indexPath)
        
        return cell
    }
}

extension MovieListViewController: UITableViewDelegate {
    
}
