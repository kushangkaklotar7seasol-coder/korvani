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
//    private let columns = [
//        GridItem(.flexible()),
//        GridItem(.flexible())
//    ]
    @State private var refreshID = UUID()
//    @EnvironmentObject var orientation: OrientationObserver
    var columns: [GridItem] {
            let count = isiPad ? (Device.isiPadLandscape ? 5 : 4) : 2
            return Array(repeating: GridItem(.flexible()), count: count)
        }
    @EnvironmentObject var adVm: AdCountViewModel
    
    var body: some View {
        ZStack {
            VStack {
                DefaultDesign.Header(name: "FAVORITE", back: {
                    self.dismiss()
                })
                .padding(.horizontal, 16)
                
                CustomSegmentedControl(preselectedIndex: $viewModel.selectedIndex, options: [Strings.movies, Strings.series])
                    .padding(.horizontal, 16)
                
                //                if viewModel.selectedIndex == 0 {
                
                ScrollView(showsIndicators: false) {
                    
                    if isShowAdd() {
                        NativeAd6()
                    }
                    
                    VStack(spacing: 0) {
                        if viewModel.selectedIndex == 0 {
                            // MARK: - Movies Section
                            if !viewModel.movies.isEmpty {
                                LazyVGrid(columns: columns) {
                                    ForEach(viewModel.movies.indices, id: \.self) { index in
                                        MovieDetail.card(
                                            movies: viewModel.movies[index],
                                            numbersOfCard: isiPad ? 4 : 2,
                                            onLike: { movie in
                                                viewModel.movies.removeAll(where: { $0.id == movie.id })
                                                DispatchQueue.main.async {
                                                    viewModel.fetchMovie()
                                                }
                                            }
                                        )
                                        .id(viewModel.movies[index].id)
                                        .onTapGesture {
                                            viewModel.selectedMovie = viewModel.movies[index]
                                            viewModel.isShowmovieDetail = true
                                            adVm.registerTap()
                                            logAnalyticAction(title: "", status: AnalyticEvent.likeScreen)
                                        }
                                    }
                                }
                                .padding(.horizontal, 16)
                                .id(refreshID)
                            }
                        } else {
                            // MARK: - Series Section
                            if !viewModel.series.isEmpty {
                                LazyVGrid(columns: columns) {
                                    ForEach(viewModel.series.indices, id: \.self) { index in
                                        MovieDetail.card(
                                            movies: viewModel.series[index],
                                            numbersOfCard: isiPad ? 4 : 2,
                                            onLike: { movie in
                                                viewModel.series.removeAll(where: { $0.id == movie.id })
                                                DispatchQueue.main.async {
                                                    viewModel.fetchSeries()
                                                }
                                            }
                                        )
                                        .id(viewModel.series[index].id)
                                        .onTapGesture {
                                            viewModel.selectedMovie = viewModel.series[index]
                                            viewModel.isShowmovieDetail = true
                                            adVm.registerTap()
                                            logAnalyticAction(title: "", status: AnalyticEvent.likeScreen)
                                        }
                                    }
                                }
                                .padding(.horizontal, 16)
                                .id(refreshID)
                            }
                        }
                        
                        Spacer()
                    }
                }
            }
            
            if viewModel.selectedIndex == 0 {
                if viewModel.movies.isEmpty {
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
                if viewModel.series.isEmpty {
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
        }
        .defaultPage()
        .edgesIgnoringSafeArea(.bottom)
        .navigationDestination(isPresented: $viewModel.isShowmovieDetail) {
            MovieDetails(viewModel: MovieDetailViewModel(movieId: viewModel.selectedMovie?.id ?? 0, isMovie: viewModel.selectedMovie?.title != nil ? true : false))
        }
        .onAppear {
            // SwipeBackManager.shared.isEnabled = true
        }
        .onReceive(
            NotificationCenter.default.publisher(
                for: UIDevice.orientationDidChangeNotification
            )
        ) { _ in
            refreshID = UUID()
        } 
    }
}

#Preview {
    LikeScreen()
}
