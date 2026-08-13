//
//  CategoryListScreen.swift
//  Korvani
//
//  Created by Kushang kaklotar on 16/07/26.
//

import SwiftUI

struct CategoryListScreen: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: CategoryListViewModel
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
                DefaultDesign.Header(name: viewModel.media.name, back:  {
                    self.dismiss()
                })
                .padding(.horizontal, 16)
                
                ScrollView(showsIndicators: false) {
                    if isShowAdd() {
                        NativeAd9()
                    }
                    
                    LazyVGrid(columns: columns) {
                        ForEach(viewModel.mediaItem.indices, id: \.self) { index in
                            MovieDetail.card(movies: viewModel.mediaItem[index], numbersOfCard: isiPad ? 4 : 2)
                                .onTapGesture {
                                    viewModel.selectedMovieId = viewModel.mediaItem[index].id
                                    viewModel.isMovieselected = viewModel.mediaItem[index].title != nil ? true : false
                                    viewModel.isShowmovieDetail = true
                                    adVm.registerTap()
                                    logAnalyticAction(title: "", status: AnalyticEvent.categoryList)
                                }
                                .onAppear() {
                                    self.loadMoreIfNeeded(currentItem: index)
                                }
                        }
                    }
                    .padding(.horizontal, 16)
                    .id(refreshID)
                }
            }
        }
        .defaultPage()
        .navigationDestination(isPresented: $viewModel.isShowmovieDetail) {
            MovieDetails(viewModel: MovieDetailViewModel(movieId: viewModel.selectedMovieId, isMovie: viewModel.isMovieselected))
        }
        .onAppear {
            // SwipeBackManager.shared.isEnabled = true
        }
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) {_ in
            refreshID = UUID()
        }
    }
    
    func loadMoreIfNeeded(currentItem: Int) {
        guard !viewModel.isLoading, currentItem == viewModel.mediaItem.count - (isiPad ? 8 : 5) else { return }
        viewModel.manageAPIs()
    }
}

#Preview {
    CategoryListScreen(viewModel: CategoryListViewModel())
}
