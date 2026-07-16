//
//  CategoryListViewModel.swift
//  Korvani
//
//  Created by Kushang kaklotar on 16/07/26.
//

import Foundation
internal import Combine

class CategoryListViewModel: ObservableObject {
    @Published var media: MediaBunch
    
    @Published var mediaCredits: MediaCredits?
    @Published var mediaItem: [MediaItem] = []
    @Published var isLoading = false
    
    init(media: MediaBunch? = nil) {
        self.media = media ?? MediaBunch(id: 0, name: "", type: .TopRatedMovie, media: MediaCredits(page: 0, totalPages: 0, totalResults: 0, results: []))
        
        self.mediaCredits = media?.media
        self.mediaItem = media?.media.results ?? []
    }
    
    func manageAPIs(){
        switch self.media.type {
        case .NewRelesesMovie:
            self.newReleaseAPI()
        case .TopRatedMovie:
            self.topRatedAPI()
        case .MostPopulerMovie:
            self.populerAPI()
        case .airingTodaySeries:
            self.airingTodayAPI()
        case .topRatedSeries:
            self.topRatedSeriesAPI()
        case .mostPopulerSeries:
            self.populerSeriesAPI()
        }
    }
    
    // MARK: - API Call's -
    func newReleaseAPI() {
        if Utility.isInternetAvailable() {
            DiscoverService.shared.newReleaseAPI(page: (self.mediaCredits?.page ?? 0)+1) { statusCode, response in
                self.mediaCredits = response
                for i in response.results {
                    self.mediaItem.append(i)
                }
            } failure: { error in
                print(error)
            }
        } else {
            print("No internet connected")
        }
    }
    
    func topRatedAPI() {
        if Utility.isInternetAvailable() {
            DiscoverService.shared.topRatedAPI(page: (self.mediaCredits?.page ?? 0)+1) { statusCode, response in
                self.mediaCredits = response
                for i in response.results {
                    self.mediaItem.append(i)
                }
            } failure: { error in
                print(error)
            }
        } else {
            print("No internet connected")
        }
    }
    
    func populerAPI() {
        if Utility.isInternetAvailable() {
            DiscoverService.shared.populerAPI(page: (self.mediaCredits?.page ?? 0)+1) { statusCode, response in
                self.mediaCredits = response
                for i in response.results {
                    self.mediaItem.append(i)
                }
            } failure: { error in
                print(error)
            }
        } else {
            print("No internet connected")
        }
    }
    
    func airingTodayAPI() {
        if Utility.isInternetAvailable() {
            DiscoverService.shared.airingTodayAPI(page: (self.mediaCredits?.page ?? 0)+1) { statusCode, response in
                self.mediaCredits = response
                for i in response.results {
                    self.mediaItem.append(i)
                }
            } failure: { error in
                print(error)
            }
        } else {
            print("No internet connected")
        }
    }
    
    func topRatedSeriesAPI() {
        if Utility.isInternetAvailable() {
            DiscoverService.shared.topRatedSeriesAPI(page: (self.mediaCredits?.page ?? 0)+1) { statusCode, response in
                self.mediaCredits = response
                for i in response.results {
                    self.mediaItem.append(i)
                }
            } failure: { error in
                print(error)
            }
        } else {
            print("No internet connected")
        }
    }
    
    func populerSeriesAPI() {
        if Utility.isInternetAvailable() {
            DiscoverService.shared.populerSeriesAPI(page: (self.mediaCredits?.page ?? 0)+1) { statusCode, response in
                self.mediaCredits = response
                for i in response.results {
                    self.mediaItem.append(i)
                }
            } failure: { error in
                print(error)
            }
        } else {
            print("No internet connected")
        }
    }
}
