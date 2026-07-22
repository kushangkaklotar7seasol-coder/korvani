//
//  CelebrityDetailsViewModel.swift
//  Korvani
//
//  Created by Kushang kaklotar on 13/07/26.
//

import Foundation
internal import Combine

class CelebrityDetailsViewModel: ObservableObject {
    @Published var celebrityDetail: PersonDetail?
    @Published var movieCredits: PersonMovieCredits?
    @Published var seriesCredits: PersonTVCredits?
    var celebrityId: Int
    @Published var personalInformation: [LanguageModel] = []
    @Published var movies: [MediaItem] = []
    
    @Published var isLoading = false
    
    @Published var selectedMovie: MediaItem?
    @Published var isShowmovieDetail = false
    
    @Published var isViewAllSheet = false
    
    init(celebrityId: Int? = nil) {
        self.celebrityId = celebrityId ?? 123
        self.celebrotyDetailAPI()
    }
    
    func celebrotyDetailAPI() {
        if Utility.isInternetAvailable() {
            CelebrityService.shared.celecrityDetailAPI(personId: self.celebrityId) { statusCode, response in
                self.celebrityDetail = response
                
                if let birthDay = self.celebrityDetail?.birthday {
                    self.personalInformation.append(LanguageModel(id: 0, name: Strings.birthday, language: birthDay))
                }
                
                if let bornYear = self.celebrityDetail?.birthday?.prefix(4) {
                    let currentYear = Calendar.current.component(.year, from: Date())
                    self.personalInformation.append(LanguageModel(id: 1, name: Strings.age, language: "\(currentYear - (Int(bornYear) ?? 0))"))
                }
                
                if let placeBirth = self.celebrityDetail?.placeOfBirth {
                    self.personalInformation.append(LanguageModel(id: 2, name: Strings.birthplace, language: placeBirth))
                }
                
                if let department = self.celebrityDetail?.knownForDepartment {
                    self.personalInformation.append(LanguageModel(id: 3, name: Strings.department, language: department))
                }
                
                self.moviesAPI()
                
            } failure: { error in
                print(error)
            }
        } else {
            Toast.shared.show(message: noInternet, type: .error)
        }
    }
    
    func calculateAge(from birthDate: Date) -> Int {
        Calendar.current.dateComponents([.year], from: birthDate, to: Date()).year ?? 0
    }
    
    // MARK: - API Call -
    func moviesAPI() {
        if Utility.isInternetAvailable() {
            self.isLoading = true
            CelebrityService.shared.celebrityMovieAPI(personId: self.celebrityId) { statusCode, response in
                self.isLoading = false
                self.movieCredits = response
                self.movies = response.cast
            } failure: { error in
                self.isLoading = false
                print(error)
            }
        } else {
            Toast.shared.show(message: noInternet, type: .error)
        }
    }
    
    func tvShowAPI() {
        if Utility.isInternetAvailable() {
            self.isLoading = true
            CelebrityService.shared.celebrityTvSeriesAPI(personId: self.celebrityId) { statusCode, response in
                self.isLoading = false
                self.seriesCredits = response
                for i in self.seriesCredits?.cast ?? [] {
                    self.movies.append(i)
                }
//                Movie(adult: i.adult, backdropPath: i.backdropPath, genreIds: i.genreIds, id: i.id, title: i.name, originalLanguage: i.originalLanguage, originalTitle: i.originalName, overview: i.overview, popularity: i.popularity, posterPath: i.posterPath, releaseDate: i.firstAirDate ?? "", softcore: i.softcore, video: false, voteAverage: i.voteAverage, voteCount: i.voteCount)
            } failure: { error in
                self.isLoading = false
                print(error)
            }
        } else {
            Toast.shared.show(message: noInternet, type: .error)
        }
    }
    
    func showMovieSeries(media: Int){
        self.movies = []
        if media == 0 {     // Movie
            if self.movieCredits?.id == nil {
                self.moviesAPI()
            } else {
                self.movies = self.movieCredits?.cast ?? []
            }
        } else {    // Series
            if self.seriesCredits?.id == nil {
                self.tvShowAPI()
            } else {
                for i in self.seriesCredits?.cast ?? [] {
                    self.movies.append(i)
                }
//                Movie(adult: i.adult, backdropPath: i.backdropPath, genreIds: i.genreIds, id: i.id, title: i.name, originalLanguage: i.originalLanguage, originalTitle: i.originalName, overview: i.overview, popularity: i.popularity, posterPath: i.posterPath, releaseDate: i.firstAirDate ?? "", softcore: i.softcore, video: false, voteAverage: i.voteAverage, voteCount: i.voteCount)
            }
        }
    }
}
