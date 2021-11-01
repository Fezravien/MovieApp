//
//  NetworkConstant.swift
//  MovieApp
//
//  Created by Fezravien on 2021/11/01.
//

import Foundation

enum NetworkConstant {
    static let clientIdentifier = "14w6bwA72wq0vfTal1be"
    static let clientSecret = "Gj77vdXeX7"
    static let baseURL = "https://openapi.naver.com/v1/search/movie"
    case get(Int, String)
    
    var url: URL? {
        switch self {
        case .get(let page, let search):
            return URL(string: NetworkConstant.baseURL + "?start=\(10*page+1)" + "?query=\(search.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")")
        }
    }
}


