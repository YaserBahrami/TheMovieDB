//
//  Endpoint.swift
//  TheMovieDB
//
//  Created by Yaser on 13.01.2025.
//

import Foundation

enum Endpoint {
    case popularMovies(page: Int)
    case searchMovies(query: String, page: Int)
    
    var url: URL? {
        let baseURL = AppConfig.baseURL
        let apiKey = AppConfig.apiKey
        switch self {
        case .popularMovies(let page):
            return URL(string: "\(baseURL)/movie/popular?api_key=\(apiKey)&page=\(page)")
        case .searchMovies(let query, let page):
            let queryString = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            return URL(string: "\(baseURL)/search/movie?api_key=\(apiKey)&query=\(queryString)&page=\(page)")
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}
