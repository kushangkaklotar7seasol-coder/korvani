//
//  MovieDetailViewModel.swift
//  Korvani
//
//  Created by Kushang kaklotar on 16/07/26.
//

import Foundation
internal import Combine
import UIKit

class MovieDetailViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var movieDetail: MediaDetail?
    @Published var movieCredits: MovieCredits?
    @Published var movieImage: MovieImages?
    @Published var movieVideo: MovieVideos?
    
    @Published var selectedCastOption: Int = 0
    @Published var selectedMediaOption: Int = 0
    
    @Published var isLiked = false
    
    @Published var selectedCelebrityId: Int?
    @Published var isShowCastDetails = false
    
    @Published var isShowPoster = false
    @Published var isShowVideo = false
    
    @Published var posterIndex: Int = 0
    @Published var isShowPosterDetail = false
    
    @Published var isShowAllCast = false
    
    @Published var isYoutubeVideo = false
    @Published var youtubeUrl = ""
    
    var movieId: Int?
    @Published var isMovie: Bool?
    @Published var personalInformation: [LanguageModel] = []
    
    @Published var mediaItems: [String] = []
    @Published var castItems: [String] = []
    
    init(movieId: Int = 237020, isMovie: Bool = true) {
        self.movieId = movieId
        self.isMovie = isMovie
        if isMovie {
            self.movieDetails()
        } else {
            self.seriesDetails()
        }
    }
    
    // MARK: - API Call's
    func movieDetails() {
        if Utility.isInternetAvailable() {
            MovieDetailService.shared.movieDetail(id: self.movieId ?? 0) { statusCode, response in
                self.movieDetail = response
                self.isLiked = database.isMovieLiked(id: self.movieId ?? 0)
                
                if let status = self.movieDetail?.status {
                    self.personalInformation.append(LanguageModel(id: 0, name: Strings.status, language: status))
                }
                
                if let language = self.movieDetail?.spokenLanguages.first?.englishName {
                    self.personalInformation.append(LanguageModel(id: 1, name: Strings.language, language: language))
                }
                
                if let runtime = self.movieDetail?.runtime, runtime != 0 {
                    self.personalInformation.append(LanguageModel(id: 2, name: Strings.runtime, language: "\(runtime)"))
                }
                
                if let revenue = self.movieDetail?.revenue, revenue != 0 {
                    self.personalInformation.append(LanguageModel(id: 2, name: Strings.revenue, language: "\(revenue)"))
                }
                
                self.movieVideoAPI()
            } failure: { error in
                print(error)
            }
        } else {
            print("No internet connected")
        }
    }
    
    func castAndCrewAPI() {
        if Utility.isInternetAvailable() {
            MovieDetailService.shared.castAndCrew(id: self.movieId ?? 0) { statusCode, response in
                self.movieCredits = response
                if !response.cast.isEmpty {
                    self.castItems.append(Strings.topCast)
                }
                if !response.crew.isEmpty {
                    self.castItems.append(Strings.coreCrew)
                }
                self.movieImageAPI()
            } failure: { error in
                print(error)
            }
        } else {
            print("No internet connected")
        }
    }
    
    func movieImageAPI() {
        if Utility.isInternetAvailable() {
            MovieDetailService.shared.movieImage(id: self.movieId ?? 0) { statusCode, response in
                self.movieImage = response
                if !response.posters.isEmpty {
                    self.mediaItems.append(Strings.poster)
                }
            } failure: { error in
                print(error)
            }
        } else {
            print("No internet connected")
        }
    }
    
    func movieVideoAPI() {
        if Utility.isInternetAvailable() {
            MovieDetailService.shared.movieVideo(id: self.movieId ?? 0) { statusCode, response in
                self.movieVideo = response
                if !response.results.isEmpty {
                    self.mediaItems.append(Strings.videos)
                }
                
                var videoKey: [Video] = []
                videoKey = response.results.filter({$0.type == "Trailer"})
                if videoKey.isEmpty {
                    videoKey = response.results.filter({$0.type == "Teaser"})
                }
                if videoKey.isEmpty {
                    if let myRes = response.results.first {
                        videoKey.append(myRes)
                    }
                }
                if let key = videoKey.first?.key {
                    self.youtubeUrl = "https://www.youtube.com/watch?v=\(key)"
                } else {
                    self.youtubeUrl = "https://www.youtube.com/results?search_query=\(self.movieDetail?.name ?? self.movieDetail?.title ?? "") Trailer"
                }
                
                self.castAndCrewAPI()
            } failure: { error in
                print(error)
            }
        } else {
            print("No internet connected")
        }
    }
    
    func seriesDetails() {
        if Utility.isInternetAvailable() {
            MovieDetailService.shared.seriesDetail(id: self.movieId ?? 0) { statusCode, response in
                print(response)
                self.movieDetail = response
                self.isLiked = database.isMovieLiked(id: self.movieId ?? 0)
                if let status = self.movieDetail?.status {
                    self.personalInformation.append(LanguageModel(id: 0, name: Strings.status, language: status))
                }
                
                if let language = self.movieDetail?.spokenLanguages.first?.englishName {
                    self.personalInformation.append(LanguageModel(id: 1, name: Strings.language, language: language))
                }
                
                if let runtime = self.movieDetail?.runtime, runtime != 0 {
                    self.personalInformation.append(LanguageModel(id: 2, name: Strings.runtime, language: "\(runtime)"))
                }
                
                if let revenue = self.movieDetail?.revenue, revenue != 0 {
                    self.personalInformation.append(LanguageModel(id: 2, name: Strings.revenue, language: "\(revenue)"))
                }
                
                if let season = self.movieDetail?.seasons?.count {
                    self.personalInformation.append(LanguageModel(id: 2, name: Strings.season, language: "\(season > 1 ? season-1 : season)"))
                }
                
                self.seriesVideoAPI()
            } failure: { error in
                print(error)
            }
        } else {
            print("No internet connected")
        }
    }
    
    func seriesCastAndCrew() {
        if Utility.isInternetAvailable() {
            MovieDetailService.shared.seriesCastAndCrew(id: self.movieId ?? 0) { statusCode, response in
                self.movieCredits = response
                if !response.cast.isEmpty {
                    self.castItems.append(Strings.topCast)
                }
                if !response.crew.isEmpty {
                    self.castItems.append(Strings.coreCrew)
                }
                self.seriesImageAPI()
            } failure: { error in
                print(error)
            }
        } else {
            print("No internet connected")
        }
    }
    
    func seriesImageAPI() {
        if Utility.isInternetAvailable() {
            MovieDetailService.shared.seriesImage(id: self.movieId ?? 0) { statusCode, response in
                self.movieImage = response
                if !response.posters.isEmpty {
                    self.mediaItems.append(Strings.poster)
                }
            } failure: { error in
                print(error)
            }
        } else {
            print("No internet connected")
        }
    }
    
    func seriesVideoAPI() {
        if Utility.isInternetAvailable() {
            MovieDetailService.shared.seriesVideo(id: self.movieId ?? 0) { statusCode, response in
                self.movieVideo = response
                if !response.results.isEmpty {
                    self.mediaItems.append(Strings.videos)
                }
                
                var videoKey: [Video] = []
                videoKey = response.results.filter({$0.type == "Trailer"})
                if videoKey.isEmpty {
                    videoKey = response.results.filter({$0.type == "Teaser"})
                }
                if videoKey.isEmpty {
                    if let myRes = response.results.first {
                        videoKey.append(myRes)
                    }
                }
                if let key = videoKey.first?.key {
                    self.youtubeUrl = "https://www.youtube.com/watch?v=\(key)"
                } else {
                    self.youtubeUrl = "https://www.youtube.com/results?search_query=\(self.movieDetail?.name ?? self.movieDetail?.title ?? "") Trailer"
                }
                
                self.seriesCastAndCrew()
            } failure: { error in
                print(error)
            }
        } else {
            print("No internet connected")
        }
    }
    
    func manageLike() {
        if self.isLiked {
            database.removeMovie(id: movieId ?? 0)
        } else {
            database.addMovie(MediaItem(adult: false, backdropPath: "", genreIds: [], id: movieId ?? 0, originalLanguage: "", overview: "", popularity: 0.0, posterPath: movieDetail?.posterPath, softcore: false, voteAverage: movieDetail?.voteAverage ?? 0.0, voteCount: 0, title: movieDetail?.title, originalTitle: "", releaseDate: "", video: false, name: movieDetail?.title, originalName: "", firstAirDate: movieDetail?.releaseDate, originCountry: [], character: "", creditId: "", episodeCount: 0, firstCreditAirDate: "", isMovie: self.isMovie ?? true ? 1 : 0))
        }
        self.isLiked.toggle()
    }
    
    func translatedText() -> String {
        return """
        \(Strings.shareText1) \(self.movieDetail?.name ?? self.movieDetail?.title ?? "")
        \(Strings.shareText2)
        """
    }
    
//    func openInYouTubeApp(videoID: String) {
//        if let url = URL(string: ) {
//            if UIApplication.shared.canOpenURL(url) {
//                UIApplication.shared.open(url, options: [:], completionHandler: nil)
//            } else {
//                if let url = URL(string: "https://www.youtube.com/watch?v=\(videoID)") {
//                    UIApplication.shared.open(url)
//                }
//            }
//        }
//    }
}
