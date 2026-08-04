//
//  DiscoverScreen.swift
//  Korvani
//
//  Created by Kushang kaklotar on 16/07/26.
//

import SwiftUI

struct DiscoverScreen: View {
    @StateObject var viewModel = DiscoverViewModel()
    @EnvironmentObject var localization: LocalizationManager
    @EnvironmentObject var adVm: AdCountViewModel
    
    var body: some View {
        ZStack {
            VStack {
                DefaultDesign.Header(name: "DISCOVERY", secondIcon: "ic_like_squre", isShowSecondbutton: true, isShowBackButton: false, font: .system(size: 20, weight: .semibold), secondButton: {
                    viewModel.isShowLikeScreen = true
                    adVm.registerTap()
                })
                .padding(.horizontal, 16)
                
                CustomSegmentedControl(preselectedIndex: $viewModel.selectedIndex, options: [Strings.movies, Strings.series]) { index in
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
                
                
                ZStack {
                    // ----------------- MOVIES TAB -----------------
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 24) {
                            ForEach(viewModel.moviesBunch, id: \.id) { item in
                                MovieDetail.MediaBunchView(
                                    item: item,
                                    onViewAll: {
                                        viewModel.selectedBunch = item
                                        viewModel.isShowCategoryScreen = true
                                        adVm.registerTap()
                                    }, onMovie: { movie in
                                        print("\(movie.name ?? "") Tap")
                                        viewModel.selectedMovie = movie
                                        viewModel.isShowmovieDetail = true
                                        adVm.registerTap()
                                    }
                                )
                                
                                if item.id == 0 {
                                    if isShowAdd() {
                                        NativeAd9()
                                    }
                                }
                            }
                        }
                        .padding(.vertical, 24)
                    }
                    .id(localization.selectedLanguage)
                    .opacity(viewModel.selectedIndex == 0 ? 1 : 0)
                    .allowsHitTesting(viewModel.selectedIndex == 0)
                    
                    // ----------------- SERIES TAB -----------------
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 24) {
                            ForEach(viewModel.seriesBunch, id: \.id) { item in
                                MovieDetail.MediaBunchView(
                                    item: item,
                                    onViewAll: {
                                        viewModel.selectedBunch = item
                                        viewModel.isShowCategoryScreen = true
                                        adVm.registerTap()
                                    }, onMovie: { movie in
                                        viewModel.selectedMovie = movie
                                        viewModel.isShowmovieDetail = true
                                        adVm.registerTap()
                                    }
                                )
                                
                                if item.id == 0 {
                                    if isShowAdd() {
                                        NativeAd9()
                                    }
                                }
                            }
                        }
                        .padding(.vertical, 24)
                    }
                    .id(localization.selectedLanguage)
                    .opacity(viewModel.selectedIndex == 1 ? 1 : 0)
                    .allowsHitTesting(viewModel.selectedIndex == 1)
                }
                
//                if viewModel.selectedIndex == 0 {
//                    ScrollView(showsIndicators: false) {
//                        VStack(spacing: 24) {
//                            ForEach(viewModel.moviesBunch, id: \.id) { item in
//                                MovieDetail.MediaBunchView(item: item,
//                                                           onViewAll: {
//                                    viewModel.selectedBunch = item
//                                    viewModel.isShowCategoryScreen = true
//                                }, onMovie: { movie in
//                                    print("\(movie.name ?? "") Tap")
//                                    viewModel.selectedMovie = movie
//                                    viewModel.isShowmovieDetail = true
//                                })
//                                
//                                if item.id == 0 {
//                                    if isShowAdd() {
//                                        NativeAd7()
//                                            .padding(.vertical, 8)
//                                    }
//                                }
//                            }
//                        }
//                        .padding(.vertical, 24)
//                    }
//                    .id(localization.selectedLanguage)
//                } else {
//                    ScrollView(showsIndicators: false) {
//                        VStack(spacing: 24) {
//                            ForEach(viewModel.seriesBunch, id: \.id) { item in
//                                MovieDetail.MediaBunchView(item: item,
//                                                           onViewAll: {
//                                    viewModel.selectedBunch = item
//                                    viewModel.isShowCategoryScreen = true
//                                }, onMovie: { movie in
//                                    viewModel.selectedMovie = movie
//                                    viewModel.isShowmovieDetail = true
//                                })
//                            }
//                        }
//                        .padding(.vertical, 24)
//                    }
//                    .id(localization.selectedLanguage)
//                }
            }
        }
        .defaultPage()
        .id(localization.selectedLanguage)
        .navigationDestination(isPresented: $viewModel.isShowCategoryScreen) {
            CategoryListScreen(viewModel: CategoryListViewModel(media: viewModel.selectedBunch))
        }
        .navigationDestination(isPresented: $viewModel.isShowLikeScreen) {
            LikeScreen()
        }
        .navigationDestination(isPresented: $viewModel.isShowmovieDetail) {
            MovieDetails(viewModel: MovieDetailViewModel(movieId: viewModel.selectedMovie?.id ?? 0, isMovie: viewModel.selectedMovie?.title != nil ? true : false))
        }
        .onAppear {
            SwipeBackManager.shared.isEnabled = false
        }
    }
}

#Preview {
    DiscoverScreen()
}
