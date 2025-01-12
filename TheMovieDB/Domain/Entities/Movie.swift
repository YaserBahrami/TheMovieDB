//
//  Movie.swift
//  TheMovieDB
//
//  Created by Yaser on 13.01.2025.
//

import Foundation
struct MovieResponse: Codable {
    let results : [Movie]
}

struct Movie: Codable {
    
    var id: Int
    var title: String
    var overview: String
    var posterPath: String?
    var backdropPath: String?
    var releaseDate: String?
    var voteAverage: Double
    var popularity: Double
    var adult: Bool
    var originalLanguage: String?
    
    
    enum CodingKeys: String, CodingKey {
        
        case id
        case title = "name"
        case overview
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "first_air_date"
        case popularity
        case voteAverage = "vote_average"
        case adult
        case originalLanguage = "original_language"
    }
    
}
