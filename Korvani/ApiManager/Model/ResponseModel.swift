//
//  ResponseModel.swift
//  Mems
//
//  Created by iMac on 03/07/24.
//

import Foundation

// MARK: - TopRated movie -
struct MovieSearchResponse: Codable {
    let page: Int
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int
 
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
 
// MARK: - Movie -
struct Movie: Codable, Identifiable {
    let adult: Bool
    let backdropPath: String?
    let genreIds: [Int]
    let id: Int
    let title: String
    let originalLanguage: String
    let originalTitle: String
    let overview: String
    let popularity: Double
    let posterPath: String?
    let releaseDate: String
    let softcore: Bool
    let video: Bool
    let voteAverage: Double
    let voteCount: Int
 
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIds = "genre_ids"
        case id
        case title
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case softcore
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}
 
// MARK: - Celebrity -
struct CelebrityResponse: Codable {
    var page: Int
    var results: [Celebrity]
    let totalPages: Int
    let totalResults: Int
 
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
 
// MARK: - Person
 
struct Celebrity: Codable, Identifiable {
    let adult: Bool
    let gender: Int
    let id: Int
    let knownForDepartment: String
    let name: String
    let originalName: String
    let popularity: Double
    let profilePath: String?
 
    enum CodingKeys: String, CodingKey {
        case adult
        case gender
        case id
        case knownForDepartment = "known_for_department"
        case name
        case originalName = "original_name"
        case popularity
        case profilePath = "profile_path"
    }
}
