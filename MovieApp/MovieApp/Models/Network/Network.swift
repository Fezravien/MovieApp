//
//  Network.swift
//  MovieApp
//
//  Created by Fezravien on 2021/11/01.
//

import Foundation

final class Network: MovieNetwork {
    private let session: MovieSession
    
    init(session: MovieSession) {
        self.session = session
    }
    
    func excuteNetwork(request: URLRequest, completion: @escaping (Result<Data, Error>) -> ()) {
        session.dataTask(with: request) { data, response, error in
            if let _ = error {
                completion(.failure(MovieError.network))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(MovieError.casting("HTTPURLResponse")))
                return
            }
            
            guard (200...299) ~= response.statusCode else {
                completion(.failure(MovieError.response(response.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(MovieError.data))
                return
            }
            
            completion(.success(data))
        }.resume()
    }
}
