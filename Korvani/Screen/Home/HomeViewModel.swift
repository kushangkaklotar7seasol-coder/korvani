//
//  HomeViewModel.swift
//  Korvani
//
//  Created by Kushang kaklotar on 10/07/26.
//

import Foundation
internal import Combine
import Alamofire

class HomeViewModel : ObservableObject {
    @Published var selectedTab = 0
    @Published var topRatedMovie: [Movie] = []
    @Published var celebrity: CelebrityResponse?
    @Published var isLoading = false
    @Published var navigationItem = (celebrity: false, movieDetail: false, weather: false)
    @Published var celebritySelectedId: Int?
    
    init() {
        self.topRatedMovieAPI()
    }
    
    func topRatedMovieAPI() {
        if Utility.isInternetAvailable() {
            isLoading = true
            HomeServices.shared.topRatedAPI { statusCode, response in
                self.isLoading = false
                self.topRatedMovie = response.results
                self.topRatedMovie.removeLast(self.topRatedMovie.count-5)
                self.celebrityAPI()
            } failure: { error in
                self.isLoading = false
                print(error)
            }
        } else {
            print("No internet connected")
        }
    }
    
    func celebrityAPI() {
        if Utility.isInternetAvailable() {
            isLoading = true
            HomeServices.shared.celecrityAPI(page: 1) { statusCode, response in
                self.isLoading = false
                self.celebrity = response
            } failure: { error in
                self.isLoading = false
                print(error)
            }
        } else {
            print("No internet connected")
        }
    }
}
