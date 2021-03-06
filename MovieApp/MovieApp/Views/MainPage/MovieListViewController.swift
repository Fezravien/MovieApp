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
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setNaviation()
        setConstraints()
        bindData()
        setDataSource()
        setDelegate()
    }
    
    // MARK: - 영화 목록 fetch
    
    private func fetchMovie(page: Int, search: String) {
        self.indicater.startAnimating()
        self.movieListViewModel.fetch(page: page, search: search) { error in
            // TODO : - 네트워크 이상 이벤트를 가지고 다른 작업을 할 수 있음
        }
    }
    
    // MARK: - MovieListViewController 설정
    
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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "star.fill"), style: .plain, target: self, action: #selector(tappedFavoriteButton))
        self.navigationItem.rightBarButtonItem?.tintColor = .systemOrange
    }
    
    @objc private func tappedFavoriteButton() {
        let favoriteListViewController = FavoriteListViewController()
        favoriteListViewController.movieListDelegate = self
        favoriteListViewController.setFavorite(favoriteList: self.movieListViewModel.movieFavoriteList ?? [])
        self.navigationController?.pushViewController(favoriteListViewController, animated: true)
    }
    
    // MARK: - MovieListViewModel과 Data Binding
    
    private func bindData() {
        self.movieListViewModel.bindItemListFetch { [unowned self] in
            DispatchQueue.main.async {
                self.movieTableView.reloadData()
            }
        }
    }
    
    // MARK: - Constraint
    
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

// MARK: - UITableView DataSource

extension MovieListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movieListViewModel.movieItemList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieListCell.identifier, for: indexPath) as? MovieListCell,
              let movieItem = self.movieListViewModel.movieItemList?[indexPath.row] else { return UITableViewCell() }
        
        cell.movieListDelegate = self
        cell.setMovieListCell(movieItem: movieItem, favorite: self.movieListViewModel.movieFavoriteList ?? [])
        
        return cell
    }
}

// MARK: - UITableView Delegate

extension MovieListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = self.movieListViewModel.movieItemList?[indexPath.row] else { return }
        let movieDetailViewController = MovieDetailViewController()
        movieDetailViewController.movieListDelegate = self
        movieDetailViewController.setDetailViewController(item: item, favorite: self.movieListViewModel.movieFavoriteList ?? [])
        self.navigationController?.pushViewController(movieDetailViewController, animated: true)
    }
}

// MARK: - UISearchBarDelegate

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

// MARK: - UITableView DataSource Prefetching (Paging)

extension MovieListViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let movies = self.movieListViewModel.movieItemList?.count
        let search = self.movieListViewModel.movieSearchText ?? ""
        
        for indexPath in indexPaths {
            if movies == indexPath.row + 2, movies == 10 {
                self.movieListViewModel.plusPage()
                fetchMovie(page: self.movieListViewModel.moviePage, search: search)
            }
        }
    }
}

// MARK: - Delegate Pattern Method

extension MovieListViewController: MovieListDelegate {
    func finishedFetch() {
        DispatchQueue.main.async {
            self.indicater.stopAnimating()
        }
    }
    
    func removeFavoriteItem(item: MovieItem) {
        self.movieListViewModel.removeFavoriteItem(item: item)
    }
    
    func addFavoriteItem(item: MovieItem) {
        self.movieListViewModel.addFavoriteItem(item: item)
    }
    
    func favoriteRefresh() {
        self.movieTableView.reloadData()
    }
}

