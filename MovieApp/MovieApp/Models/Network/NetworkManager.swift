//
//  NetworkManager.swift
//  MovieApp
//
//  Created by Fezravien on 2021/11/01.
//

import Foundation

final class NetworkManager {
    private let networkLoader: MovieNetwork
    private let decoder: MovieDecoder
    
    init(networkLoader: MovieNetwork, decoder: MovieDecoder) {
        self.networkLoader = networkLoader
        self.decoder = decoder
    }
    
    func fetch(request: URLRequest, completion: @escaping (Result<MovieItemList, Error>) -> ()) {
        self.networkLoader.excuteNetwork(request: request) { result in
            switch result {
            case .success(let data):
                do {
                    let jsonDecode = try self.decoder.decode(MovieItemList.self, from: data)
                    completion(.success(jsonDecode))
                } catch {
                    completion(.failure(MovieError.decode))
                }
            case .failure(_):
                completion(.failure(MovieError.network))
            }
        }
    }
    
    func createRequest(page: Int, search: String) -> URLRequest? {
        guard let url = NetworkConstant.get(page, search).url else { return nil }
        
        var request = URLRequest(url: url)
        request.addValue(NetworkConstant.clientIdentifier, forHTTPHeaderField: "X-Naver-Client-Id")
        request.addValue(NetworkConstant.clientSecret, forHTTPHeaderField: "X-Naver-Client-Secret")
        
        return request
    }
}
