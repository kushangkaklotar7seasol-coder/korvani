//
//  SearchViewModel.swift
//  Korvani
//
//  Created by Kushang kaklotar on 15/07/26.
//

import Foundation
internal import Combine

class SearchViewModel: ObservableObject {
    @Published var searchTextField: String = ""
    @Published var isLoading = false
    @Published var moviesResponse: MediaCredits?
    @Published var seriesResponse: MediaCredits?
    
    @Published var movies: [MediaItem] = []
    @Published var series: [MediaItem] = []
    
    private var cancellables = Set<AnyCancellable>()
    @Published var selectedIndex: Int = 0
    
    init() {
        $searchTextField
            .debounce(for: .seconds(0.8), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] finalValue in
                self?.perform(finalValue)
            }
            .store(in: &cancellables)
    }
    
    func perform(_ text: String) {
        if self.selectedIndex == 0 {
            if self.searchTextField != "" {
                self.moviesSearchAPI(text: text.trimmingCharacters(in: .whitespacesAndNewlines))
            }
        } else {
            if self.searchTextField != "" {
                self.searchSeriesAPI(text: text.trimmingCharacters(in: .whitespacesAndNewlines))
            }
        }
    }
    
    func manageAPICalls(index: Int){
        if index == 0 {
            if movies.isEmpty {
                if self.searchTextField != "" {
                    self.moviesSearchAPI(text: self.searchTextField.trimmingCharacters(in: .whitespacesAndNewlines))
                }
            }
        } else {
            if series.isEmpty {
                if self.searchTextField != "" {
                    self.searchSeriesAPI(text: self.searchTextField.trimmingCharacters(in: .whitespacesAndNewlines))
                }
            }
        }
    }
    
    // MARK: - API Call's -
    func moviesSearchAPI(text: String, isFromPagination: Bool = false) {
        if Utility.isInternetAvailable() {
            self.isLoading = true
            HomeServices.shared.searchMovieAPI(text: text, page: isFromPagination ? (self.moviesResponse?.page ?? 1)+1 : self.moviesResponse?.page ?? 1) { statusCode, response in
                self.isLoading = false
                self.moviesResponse = response
                print(response.page)
                
                for i in response.results {
                    self.movies.append(i)
                }
                
            } failure: { error in
                self.isLoading = false
                print(error)
            }
        } else {
            print("No internet connected")
        }
    }
    
    func searchSeriesAPI(text: String, isFromPagination: Bool = false) {
        if Utility.isInternetAvailable() {
            self.isLoading = true
            HomeServices.shared.searchSeriesAPI(text: text, page: isFromPagination ? (self.seriesResponse?.page ?? 1)+1 : self.seriesResponse?.page ?? 1) { statusCode, response in
                self.isLoading = false
                self.seriesResponse = response
                print(response.page)
                
                for i in response.results {
                    self.series.append(i)
                }
            } failure: { error in
                self.isLoading = false
                print(error)
            }
        } else {
            print("No internet connected")
        }
    }
}
