//
//  DiscoverViewModel.swift
//  Korvani
//
//  Created by Kushang kaklotar on 16/07/26.
//

import Foundation
internal import Combine

class DiscoverViewModel: ObservableObject {
    @Published var selectedIndex = 0
    @Published var moviesBunch: [MediaBunch] = []
    @Published var seriesBunch: [MediaBunch] = []
    
    @Published var selectedBunch: MediaBunch?
    @Published var isShowCategoryScreen = false
    @Published var isShowLikeScreen = false
    
    @Published var selectedMovie: MediaItem?
    @Published var isShowmovieDetail = false
    
    init() {
        self.newReleaseAPI()
    }
    
    // MARK: - API Call's    
    func newReleaseAPI() {
        if Utility.isInternetAvailable() {
            DiscoverService.shared.newReleaseAPI { statusCode, response in
                self.moviesBunch.append(MediaBunch(id: 0, name: "NEW_RELEASE", type: .NewRelesesMovie, media: response))
                self.topRatedAPI()
            } failure: { error in
                print(error)
            }
        } else {
            print("No internet connected")
        }
    }
    
    func topRatedAPI() {
        if Utility.isInternetAvailable() {
            DiscoverService.shared.topRatedAPI { statusCode, response in
                self.moviesBunch.append(MediaBunch(id: 1, name: "TOP_RATED", type: .TopRatedMovie, media: response))
                self.populerAPI()
            } failure: { error in
                print(error)
            }
        } else {
            print("No internet connected")
        }
    }
    
    func populerAPI() {
        if Utility.isInternetAvailable() {
            DiscoverService.shared.populerAPI { statusCode, response in
                self.moviesBunch.append(MediaBunch(id: 2, name: "MOST_POPULAR", type: .MostPopulerMovie, media: response))
            } failure: { error in
                print(error)
            }
        } else {
            print("No internet connected")
        }
    }
    
    func airingTodayAPI() {
        if Utility.isInternetAvailable() {
            DiscoverService.shared.airingTodayAPI { statusCode, response in
                self.seriesBunch.append(MediaBunch(id: 0, name: "ARRIVING_TODAY", type: .airingTodaySeries, media: response))
                self.topRatedSeriesAPI()
            } failure: { error in
                print(error)
            }
        } else {
            print("No internet connected")
        }
    }
    
    func topRatedSeriesAPI() {
        if Utility.isInternetAvailable() {
            DiscoverService.shared.topRatedSeriesAPI { statusCode, response in
                self.seriesBunch.append(MediaBunch(id: 1, name: "TOP_RATED", type: .topRatedSeries, media: response))
                self.populerSeriesAPI()
            } failure: { error in
                print(error)
            }
        } else {
            print("No internet connected")
        }
    }
    
    func populerSeriesAPI() {
        if Utility.isInternetAvailable() {
            DiscoverService.shared.populerSeriesAPI { statusCode, response in
                self.seriesBunch.append(MediaBunch(id: 2, name: "MOST_POPULAR", type: .mostPopulerSeries, media: response))
            } failure: { error in
                print(error)
            }
        } else {
            print("No internet connected")
        }
    }
}
