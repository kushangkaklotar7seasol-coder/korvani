//
//  DiscoverScreen.swift
//  Korvani
//
//  Created by Kushang kaklotar on 16/07/26.
//

import SwiftUI

struct DiscoverScreen: View {
    @StateObject var viewModel = DiscoverViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                DefaultDesign.Header(name: "Discover", secondIcon: "ic_like_squre", isShowSecondbutton: true, isShowBackButton: false, font: .system(size: 20, weight: .semibold), secondButton: {
                    viewModel.isShowLikeScreen = true
                })
                    .padding(.horizontal, 16)
                
                CustomSegmentedControl(preselectedIndex: $viewModel.selectedIndex, options: ["Movies", "Series"]) { index in
                    if index == 0 {
                        if viewModel.moviesBunch.isEmpty {
                            viewModel.newReleaseAPI()
                        }
                    } else {
                        if viewModel.seriesBunch.isEmpty {
                            viewModel.airingTodayAPI()
                        }
                    }
                }
                .padding(.horizontal, 16)
                
                if viewModel.selectedIndex == 0 {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 24) {
                            ForEach(viewModel.moviesBunch, id: \.id) { item in
                                MovieDetail.MediaBunchView(item: item,
                                                           onViewAll: {
                                    viewModel.selectedBunch = item
                                    viewModel.isShowCategoryScreen = true
                                }, onMovie: { movie in
                                    print("\(movie.name ?? "") Tap")
                                    viewModel.selectedMovie = movie
                                    viewModel.isShowmovieDetail = true
                                })
                            }
                        }
                        .padding(.vertical, 24)
                    }
                } else {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 24) {
                            ForEach(viewModel.seriesBunch, id: \.id) { item in
                                MovieDetail.MediaBunchView(item: item,
                                                           onViewAll: {
                                    viewModel.selectedBunch = item
                                    viewModel.isShowCategoryScreen = true
                                }, onMovie: { movie in
                                    viewModel.selectedMovie = movie
                                    viewModel.isShowmovieDetail = true
                                })
                            }
                        }
                        .padding(.vertical, 24)
                    }
                }
            }
        }
        .defaultPage()
        .navigationDestination(isPresented: $viewModel.isShowCategoryScreen) {
            CategoryListScreen(viewModel: CategoryListViewModel(media: viewModel.selectedBunch))
        }
        .navigationDestination(isPresented: $viewModel.isShowLikeScreen) {
            LikeScreen()
        }
        .navigationDestination(isPresented: $viewModel.isShowmovieDetail) {
            MovieDetails(viewModel: MovieDetailViewModel(movieId: viewModel.selectedMovie?.id ?? 0, isMovie: viewModel.selectedMovie?.title != nil ? true : false))
        }
    }
}

#Preview {
    DiscoverScreen()
}
