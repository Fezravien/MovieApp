//
//  MovieListViewController.swift
//  MovieApp
//
//  Created by Fezravien on 2021/11/01.
//

import UIKit

class MovieListViewController: UIViewController, MovieListDelegate {
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

    override func viewDidLoad() {
        super.viewDidLoad()
        setNaviation()
        setConstraints()
        bindData()
        setDataSource()
        setDelegate()
    }
    
    func finishedFetch() {
        DispatchQueue.main.async {
            self.indicater.stopAnimating()
        }
    }
    
    private func fetchMovie(page: Int, search: String) {
        self.movieListViewModel.fetch(page: page, search: search) { [unowned self] error in
            if let error = error, let networkError = error as? MovieError {
                self.alert(title: networkError.descripion)
                return
            }
            
            DispatchQueue.main.async {
                self.indicater.startAnimating()
            }
        }
    }

    
    private func setDataSource() {
        self.movieTableView.dataSource = self
        self.movieTableView.prefetchDataSource = self
    }
    
    private func setDelegate() {
        self.movieTableView.delegate = self
        self.searchController.searchBar.delegate = self
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
        
        cell.movieListDelegate = self
        cell.setMovieListCell(movieItem: movieItem, indexPath: indexPath)
        
        return cell
    }
}

extension MovieListViewController: UITableViewDelegate {
    
}

extension MovieListViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        self.movieListViewModel.resetItemList()
        self.movieListViewModel.resetPage()
        self.movieListViewModel.setSearchText(search: searchText)
        fetchMovie(page: self.movieListViewModel.moviePage, search: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            self.indicater.stopAnimating()
        }
    }
}

extension MovieListViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let movies = self.movieListViewModel.movieItemList?.count
        let page = self.movieListViewModel.moviePage
        let search = self.movieListViewModel.movieSearchText ?? ""
        
        for indexPath in indexPaths {
            if movies == indexPath.row + 2, movies == 10 {
                self.movieListViewModel.plusPage()
                fetchMovie(page: page, search: search)
            }
        }
    }
}
