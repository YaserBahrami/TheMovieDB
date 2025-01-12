//
//  Movie.swift
//  TheMovieDB
//
//  Created by Yaser on 13.01.2025.
//

import Foundation

struct APIResponse<T: Decodable>: Decodable {
    let results: [T]
}

struct Movie: Decodable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    var backdropPath: String?
    var releaseDate: String?
    var voteAverage: Double
    var popularity: Double
    var adult: Bool
    var originalLanguage: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "first_air_date"
        case popularity
        case voteAverage = "vote_average"
        case adult
        case originalLanguage = "original_language"
    }
    
    var posterImageURL: URL? {
        guard let path = posterPath else { return nil }
        return URL(string: AppConfig.imageBaseURL + path)
    }
    
    var backdropImageURL: URL? {
        guard let path = backdropPath else { return nil }
        return URL(string: AppConfig.imageBaseURL + path)
    }
}
