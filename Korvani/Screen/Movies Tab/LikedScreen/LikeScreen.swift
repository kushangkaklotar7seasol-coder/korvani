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
                DefaultDesign.Header(name: "FAVORITE", back: {
                    self.dismiss()
                })
                
                CustomSegmentedControl(preselectedIndex: $viewModel.selectedIndex, options: [Strings.movies, Strings.series])
                
                if viewModel.selectedIndex == 0 {
                    if !viewModel.movies.isEmpty {
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
                        VStack {
                            Spacer()
                            Image("ic_no_favorite")
                                .resizable()
                                .frame(width: 120, height: 120, alignment: .center)
                            
                            Text(Strings.noFavourite)
                                .foregroundColor(.whiteColour)
                                .font(.system(size: 18, weight: .medium))
                            
                            Text(Strings.noFavouriteMovie)
                                .foregroundColor(.grayColour)
                                .font(.system(size: 14, weight: .regular))
                            Spacer()
                        }
                    }
                } else {
                    if !viewModel.series.isEmpty {
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
                    } else {
                        VStack {
                            Spacer()
                            Image("ic_no_favorite")
                                .resizable()
                                .frame(width: 120, height: 120, alignment: .center)
                            
                            Text(Strings.noFavourite)
                                .foregroundColor(.whiteColour)
                                .font(.system(size: 18, weight: .medium))
                            
                            Text(Strings.noFavouriteSeries)
                                .foregroundColor(.grayColour)
                                .font(.system(size: 14, weight: .regular))
                            Spacer()
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
        .onAppear {
            SwipeBackManager.shared.isEnabled = true
        }
    }
}

#Preview {
    LikeScreen()
}
