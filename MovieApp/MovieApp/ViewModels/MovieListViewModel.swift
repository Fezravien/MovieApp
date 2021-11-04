//
//  MovieListViewModel.swift
//  MovieApp
//
//  Created by Fezravien on 2021/11/04.
//

import Foundation

final class MovieListViewModel {
    private var itemListFetchHandler: (() -> Void)?
    private var itemImageHandler: (() -> Void)?
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
    
    init(session: MovieSession = URLSession.shared) {
        self.session = session
    }
    
    func bindItemListFetch(itemListFetchHandler: @escaping () -> Void) {
        self.itemListFetchHandler = itemListFetchHandler
    }
    
    func bindItemImage(itemImageHandler: @escaping () -> Void) {
        self.itemImageHandler = itemImageHandler
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
    
    func convertDirector() -> String {
        guard let item = self.movieItem else { return "" }
        let diector = item.director
        let dumpCharactorCount = diector.filter { $0 == "|" }.count
        var convertedDirector = diector.trimmingCharacters(in: ["|"])
        
        if dumpCharactorCount > 1 {
            convertedDirector = convertedDirector.replacingOccurrences(of: "|", with: ", ")
            return convertedDirector
        }
   
        return "감독 : \(convertedDirector)"
    }
    
    func convertActor() -> String {
        guard let item = self.movieItem else { return "" }
        let actor = item.actor
        let dumpCharactorCount = actor.filter { $0 == "|" }.count
        var convertedActor = actor.trimmingCharacters(in: ["|"])
        
        if dumpCharactorCount > 1 {
            convertedActor = convertedActor.replacingOccurrences(of: "|", with: ", ")
            return convertedActor
        }
   
        return "출연 : \(convertedActor)"
    }
    
    func convertRating() -> String {
        guard let item = self.movieItem else { return "" }
        let rating = item.userRating
        let dumpCharactorCount = rating.filter { $0 == "|" }.count
        var convertedRating = rating.trimmingCharacters(in: ["|"])
        
        if dumpCharactorCount > 1 {
            convertedRating = convertedRating.replacingOccurrences(of: "|", with: ", ")
            return convertedRating
        }
   
        return "평점 : \(convertedRating)"
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
