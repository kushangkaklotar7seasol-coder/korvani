//
//  LikeViewModel.swift
//  Korvani
//
//  Created by Kushang kaklotar on 16/07/26.
//

import Foundation
internal import Combine

class LikeViewModel: ObservableObject {
    @Published var movies: [MediaItem] = []
    @Published var series: [MediaItem] = []
    @Published var selectedIndex = 0
    
    @Published var selectedMovie: MediaItem?
    @Published var isShowmovieDetail = false
    
    init() {
        for i in database.fetchMovies() {
            if i.isMovie == 1 {
                self.movies.append(i)
            } else {
                self.series.append(i)
            }
        }
    }
    
    func fetchMovie(){
        for i in database.fetchMovies() {
            if i.isMovie == 1 {
                self.movies.append(i)
            }
        }
    }
    
    func fetchSeries(){
        for i in database.fetchMovies() {
            if i.isMovie != 1 {
                self.series.append(i)
            }
        }
    }
}
