//
//  LikeScreen.swift
//  Korvani
//
//  Created by Kushang kaklotar on 16/07/26.
//

import SwiftUI

struct LikeScreen: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel = LikeViewModel()
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ZStack {
            VStack {
                DefaultDesign.Header(name: "Favorite", back: {
                    self.dismiss()
                })
                
                CustomSegmentedControl(preselectedIndex: $viewModel.selectedIndex, options: ["Movies", "Series"])
                
                if viewModel.selectedIndex == 0 {
                    ScrollView(showsIndicators: false) {
                        LazyVGrid(columns: columns) {
                            ForEach(viewModel.movies.indices, id: \.self) { index in
                                MovieDetail.card(movies: viewModel.movies[index], numbersOfCard: 2, onLike: { value in
                                    viewModel.movies.remove(at: index)
                                    let newArr = viewModel.movies
                                    viewModel.movies = []
                                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                                        viewModel.movies = newArr
                                    }
                                })
                                .onTapGesture {
                                    viewModel.selectedMovie = viewModel.movies[index]
                                    viewModel.isShowmovieDetail = true
                                }
                            }
                        }
                    }
                } else {
                    ScrollView(showsIndicators: false) {
                        LazyVGrid(columns: columns) {
                            ForEach(viewModel.series.indices, id: \.self) { index in
                                MovieDetail.card(movies: viewModel.series[index], numbersOfCard: 2, onLike: { value in
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        viewModel.series.remove(at: index)
                                        let newArr = viewModel.series
                                        viewModel.series = []
                                        DispatchQueue.main.asyncAfter(deadline: .now()) {
                                            viewModel.series = newArr
                                        }
                                    }
                                })
                                .onTapGesture {
                                    viewModel.selectedMovie = viewModel.movies[index]
                                    viewModel.isShowmovieDetail = true
                                }
                            }
                        }
                    }
                }
                
                Spacer()
            }
        }
        .padding(.horizontal, 16)
        .defaultPage()
        .edgesIgnoringSafeArea(.bottom)
        .navigationDestination(isPresented: $viewModel.isShowmovieDetail) {
            MovieDetails(viewModel: MovieDetailViewModel(movieId: viewModel.selectedMovie?.id ?? 0, isMovie: viewModel.selectedMovie?.title != nil ? true : false))
        }
    }
}

#Preview {
    LikeScreen()
}
