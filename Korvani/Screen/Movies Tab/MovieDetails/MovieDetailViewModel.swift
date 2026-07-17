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
    @Published var movieDetail: MovieDetailModel?
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
    
    var movieId: Int?
    
    init(movieId: Int = 278) {
        self.movieId = movieId
        self.movieDetails()
    }
    
    // MARK: - API Call's
    func movieDetails() {
        if Utility.isInternetAvailable() {
            MovieDetailService.shared.movieDetail(id: self.movieId ?? 0) { statusCode, response in
                self.movieDetail = response
                self.isLiked = database.isMovieLiked(id: self.movieId ?? 0)
                self.castAndCrewAPI()
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
                self.movieVideoAPI()
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
            database.addMovie(MediaItem(adult: false, backdropPath: "", genreIds: [], id: movieId ?? 0, originalLanguage: "", overview: "", popularity: 0.0, posterPath: movieDetail?.posterPath, softcore: false, voteAverage: movieDetail?.voteAverage ?? 0.0, voteCount: 0, title: movieDetail?.title, originalTitle: "", releaseDate: "", video: false, name: movieDetail?.title, originalName: "", firstAirDate: movieDetail?.releaseDate, originCountry: [], character: "", creditId: "", episodeCount: 0, firstCreditAirDate: "", isMovie: 1))
        }
        self.isLiked.toggle()
    }
    
    func openInYouTubeApp(videoID: String) {
        if let url = URL(string: "youtube://www.youtube.com/watch?v=\(videoID)") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                if let url = URL(string: "https://www.youtube.com/watch?v=\(videoID)") {
                    UIApplication.shared.open(url)
                }
            }
        }
    }
}
