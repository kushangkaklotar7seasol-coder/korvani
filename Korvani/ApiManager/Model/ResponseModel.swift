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
 
// MARK: - Person -
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

// MARK: - Person Details -
struct PersonDetail: Codable, Identifiable {
    let adult: Bool
    let alsoKnownAs: [String]
    let biography: String
    let birthday: String?
    let deathday: String?
    let gender: Int
    let homepage: String?
    let id: Int
    let imdbId: String?
    let knownForDepartment: String
    let name: String
    let placeOfBirth: String?
    let popularity: Double
    let profilePath: String?
 
    enum CodingKeys: String, CodingKey {
        case adult
        case alsoKnownAs = "also_known_as"
        case biography
        case birthday
        case deathday
        case gender
        case homepage
        case id
        case imdbId = "imdb_id"
        case knownForDepartment = "known_for_department"
        case name
        case placeOfBirth = "place_of_birth"
        case popularity
        case profilePath = "profile_path"
    }
}

// MARK: - Celebrity related movie -
struct PersonMovieCredits: Codable {
    let cast: [MediaItem]
    let id: Int
}

struct PersonTVCredits: Codable {
    let cast: [MediaItem]
    let id: Int
}

struct TVCastCredit: Codable, Identifiable {
    let adult: Bool
    let backdropPath: String?
    let genreIds: [Int]
    let id: Int
    let originCountry: [String]
    let originalLanguage: String
    let originalName: String
    let overview: String
    let popularity: Double
    let posterPath: String?
    let firstAirDate: String?
    let softcore: Bool
    let name: String
    let voteAverage: Double
    let voteCount: Int
    let character: String
    let creditId: String
    let episodeCount: Int
    let firstCreditAirDate: String?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIds = "genre_ids"
        case id
        case originCountry = "origin_country"
        case originalLanguage = "original_language"
        case originalName = "original_name"
        case overview
        case popularity
        case posterPath = "poster_path"
        case firstAirDate = "first_air_date"
        case softcore
        case name
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case character
        case creditId = "credit_id"
        case episodeCount = "episode_count"
        case firstCreditAirDate = "first_credit_air_date"
    }
}

struct MediaCredits: Codable {
    var page: Int
    var totalPages: Int
    var totalResults: Int
    var results: [MediaItem]
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct MediaItem: Codable, Identifiable {
    // Shared fields
    let adult: Bool
    let backdropPath: String?
    let genreIds: [Int]
    let id: Int
    let originalLanguage: String
    let overview: String
    let popularity: Double
    let posterPath: String?
    let softcore: Bool
    let voteAverage: Double
    let voteCount: Int
 
    // Movie-only fields
    let title: String?
    let originalTitle: String?
    let releaseDate: String?
    let video: Bool?
 
    // TV-only fields
    let name: String?
    let originalName: String?
    let firstAirDate: String?
    let originCountry: [String]?
 
    // TV credit-only fields (present when this item comes from a person's TV credits)
    let character: String?
    let creditId: String?
    let episodeCount: Int?
    let firstCreditAirDate: String?
    
    var isMovie: Int? // 1=Movie, 0=Series
 
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIds = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case overview
        case popularity
        case posterPath = "poster_path"
        case softcore
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
 
        case title
        case originalTitle = "original_title"
        case releaseDate = "release_date"
        case video
 
        case name
        case originalName = "original_name"
        case firstAirDate = "first_air_date"
        case originCountry = "origin_country"
 
        case character
        case creditId = "credit_id"
        case episodeCount = "episode_count"
        case firstCreditAirDate = "first_credit_air_date"
    }
}



































// MARK: - Weather -
struct WeatherForecastResponse: Codable {
    let cod: String
    let message: Int
    let cnt: Int
    let list: [ForecastItem]
    let city: City
}
 
// MARK: ForecastItem
 
struct ForecastItem: Codable, Identifiable {
    let dt: Int
    let main: MainWeather
    let weather: [WeatherCondition]
    let clouds: Clouds
    let wind: Wind
    let visibility: Int
    let pop: Double
    let rain: Precipitation?
    let snow: Precipitation?
    let sys: Sys
    let dtTxt: String
 
    var id: Int { dt }
 
    enum CodingKeys: String, CodingKey {
        case dt
        case main
        case weather
        case clouds
        case wind
        case visibility
        case pop
        case rain
        case snow
        case sys
        case dtTxt = "dt_txt"
    }
}
 
// MARK: MainWeather
 
struct MainWeather: Codable {
    let temp: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
    let pressure: Int
    let seaLevel: Int
    let grndLevel: Int
    let humidity: Int
    let tempKf: Double
    let dewPoint: Double?
 
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
        case dewPoint = "dew_point"
    }
}
 
// MARK: WeatherCondition
 
struct WeatherCondition: Codable, Identifiable {
    let id: Int
    let main: String
    let description: String
    let icon: String
 
    /// Full icon image URL from OpenWeatherMap.
    var iconURL: URL? {
        URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")
    }
}
 
// MARK: Clouds
 
struct Clouds: Codable {
    let all: Int
}
 
// MARK: Wind
 
struct Wind: Codable {
    let speed: Double
    let deg: Int
    let gust: Double?
}
 
// MARK: Precipitation (rain / snow)
struct Precipitation: Codable {
    let threeHour: Double?
 
    enum CodingKeys: String, CodingKey {
        case threeHour = "3h"
    }
}
 
// MARK: Sys
struct Sys: Codable {
    /// Part of day: "d" for day, "n" for night.
    let pod: String
}

// MARK:  City
struct City: Codable {
    let id: Int
    let name: String
    let coord: Coordinate
    let country: String
    let population: Int
    let timezone: Int
    let sunrise: Int
    let sunset: Int
}
 
// MARK:  Coordinate
struct Coordinate: Codable {
    let lat: Double
    let lon: Double
}

// MARK: - Wallpaper -
struct WallpaperListResponse: Codable {
    var total: Int
    var page: Int
    var limit: Int
    var totalPages: Int
    var data: [Wallpaper]
}
 
// MARK: Photo
struct Wallpaper: Codable, Identifiable {
    let src: PhotoSources
    let id: String
    let pexelsId: Int
    let width: Int
    let height: Int
    let url: String
    let alt: String
    let photographer: String
    let photographerId: Int
    let photographerUrl: String
    let avgColor: String
    let liked: Bool
    let category: String
    let createdAt: String
    let updatedAt: String
    let v: Int
 
    enum CodingKeys: String, CodingKey {
        case src
        case id = "_id"
        case pexelsId
        case width
        case height
        case url
        case alt
        case photographer
        case photographerId
        case photographerUrl
        case avgColor
        case liked
        case category
        case createdAt
        case updatedAt
        case v = "__v"
    }
}
 
// MARK: PhotoSources
 
struct PhotoSources: Codable {
    let original: String
    let large2x: String
    let large: String
    let medium: String
    let small: String
    let portrait: String
    let landscape: String
    let tiny: String
}
