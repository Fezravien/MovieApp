//
//  MovieListViewModel.swift
//  MovieApp
//
//  Created by Fezravien on 2021/11/04.
//

import Foundation

final class MovieListViewModel {
    
    enum MovieInformation {
        case diector
        case actor
        case rating
    }
    
    private var itemListFetchHandler: (() -> Void)?
    private var itemImageHandler: (() -> Void)?
    private var favoriteListHandler: (() -> Void)?
    private var favoriteHandler: (() -> Void)?
    private let session: MovieSession
    private(set) var movieItem: MovieItem?
    private(set) var moviePage = 0
    private(set) var movieSearchText: String?
    private(set) var movieItemList: [MovieItem]? {
        didSet {
            itemListFetchHandler?()
        }
    }
    private(set) var movieImage: Data? {
        didSet {
            itemImageHandler?()
        }
    }
    private(set) var movieFavoriteList: [MovieItem]? {
        didSet {
            favoriteListHandler?()
        }
    }
    private(set) var movieFavorite = false {
        didSet {
            favoriteHandler?()
        }
    }
    
    init(session: MovieSession = URLSession.shared) {
        self.session = session
    }
    
    func bindItemListFetch(itemListFetchHandler: @escaping () -> Void) {
        self.itemListFetchHandler = itemListFetchHandler
    }
    
    func bindItemImage(itemImageHandler: @escaping () -> Void) {
        self.itemImageHandler = itemImageHandler
    }
    
    func bindMovieFavoriteList(favoriteListHandler: @escaping () -> Void) {
        self.favoriteListHandler = favoriteListHandler
    }
    
    func bindMovieFavorite(favoriteHandler: @escaping () -> Void) {
        self.favoriteHandler = favoriteHandler
    }
    
    func toggleFavortie(favorite: Bool) {
        self.movieFavorite = favorite
    }
    
    func addFavoriteItem(item: MovieItem) {
        if let _ = self.movieFavoriteList {
            self.movieFavoriteList?.append(item)
        } else {
            self.movieFavoriteList = [item]
        }
    }
    
    func addFavoriteItems(items: [MovieItem]) {
        self.movieFavoriteList = items
    }
    
    func removeFavoriteItem(item: MovieItem) {
        guard let favoriteList = self.movieFavoriteList,
              let index = favoriteList.firstIndex(of: item) else {
                  
                  return
              }

        self.movieFavoriteList?.remove(at: index)
    }
    
    func indexPathForRemoveItem(item: MovieItem) -> IndexPath {
        guard let favoriteList = self.movieFavoriteList,
              let indexPath = favoriteList.firstIndex(of: item) else {
                  
                  return IndexPath()
              }
        
        return IndexPath(row: indexPath, section: .zero)
    }
    
    func setItem(movieItem: MovieItem) {
        self.movieItem = movieItem
    }
    
    func resetItemList() {
        self.movieItemList = []
    }
    
    func plusPage() {
        self.moviePage += 1
    }
    
    func resetPage() {
        self.moviePage = 0
    }
    
    func setSearchText(search: String) {
        self.movieSearchText = search
    }
    
    func resetSearchText() {
        self.movieSearchText = nil
    }
    
    func convertTitle() -> String {
        guard let item = self.movieItem else { return "" }
        let title = item.title
        
        if title.hasPrefix("<b>") {
            var convertedTitlt = title.replacingOccurrences(of: "<b>", with: "")
            convertedTitlt = convertedTitlt.replacingOccurrences(of: "</b>", with: " ")
            return convertedTitlt
        } else if title.hasSuffix("</b>") {
            var convertedTitlt = title.replacingOccurrences(of: "<b>", with: " ")
            convertedTitlt = convertedTitlt.replacingOccurrences(of: "</b>", with: "")
            return convertedTitlt
        } else {
            var convertedTitlt = title.replacingOccurrences(of: "<b>", with: " ")
            convertedTitlt = convertedTitlt.replacingOccurrences(of: "</b>", with: " ")
            return convertedTitlt
        }
    }
    
    func convertFormat(movieText: String, movieInformation: MovieInformation) -> String {
        let dumpCharactorCount = movieText.filter { $0 == "|" }.count
        var convertedText = movieText.trimmingCharacters(in: ["|"])
        
        switch movieInformation {
        case .diector:
            if dumpCharactorCount > 1 {
                convertedText = convertedText.replacingOccurrences(of: "|", with: ", ")
                return convertedText
            }
       
            return "감독 : \(convertedText)"
            
        case .actor:
            if dumpCharactorCount > 1 {
                convertedText = convertedText.replacingOccurrences(of: "|", with: ", ")
                return convertedText
            }
       
            return "출연 : \(convertedText)"
            
        case .rating:
            if dumpCharactorCount > 1 {
                convertedText = convertedText.replacingOccurrences(of: "|", with: ", ")
                return convertedText
            }
       
            return "평점 : \(convertedText)"
        }
    }
    
    func fetch(page: Int, search: String, completion: @escaping (Error?) -> Void) {
        let networkManager = NetworkManager(networkLoader: Network(session: self.session), decoder: JSONDecoder())
        guard let request = networkManager.createRequest(page: page, search: search) else { return }
        
        networkManager.fetch(request: request) { result in
            switch result {
            case .success(let data):
                if let _ = self.movieItemList {
                    self.movieItemList?.append(contentsOf: data.items)
                } else {
                    self.movieItemList = data.items
                }
                completion(nil)
            case .failure(_):
                completion(MovieError.network)
            }
        }
    }
    
    func downloadImage(_ imageURL: String) {
        guard let url = URL(string: imageURL) else { return }
        DispatchQueue.global(qos: .utility).async {
            guard let imageData = try? Data(contentsOf: url) else { return }
            self.movieImage = imageData
        }
    }
}
