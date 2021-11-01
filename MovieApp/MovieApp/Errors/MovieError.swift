//
//  MovieError.swift
//  MovieApp
//
//  Created by Fezravien on 2021/11/01.
//

import Foundation

enum MovieError: Error {
    case network
    case casting(String)
    case response(Int)
    case data
    case decode
}

extension MovieError {
    var descripion: String {
        switch self {
        case .network:
            return "⛔️ 네트워크 오류"
        case .casting(let error):
            return "⛔️ 케스팅 오류: \(error) "
        case .response(let state):
            return "⛔️ 오류 코드: \(state)"
        case .data:
            return "⛔️ 데이터 오류"
        case .decode:
            return "⛔️ 디코딩 오류"
        }
    }
}
