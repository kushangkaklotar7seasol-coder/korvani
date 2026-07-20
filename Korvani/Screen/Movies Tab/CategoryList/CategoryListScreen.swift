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
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ZStack {
            VStack {
                DefaultDesign.Header(name: viewModel.media.name, back:  {
                    self.dismiss()
                })
                
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: columns) {
                        ForEach(viewModel.mediaItem.indices, id: \.self) { index in
                            MovieDetail.card(movies: viewModel.mediaItem[index], numbersOfCard: 2)
                                .onTapGesture {
                                    viewModel.selectedMovieId = viewModel.mediaItem[index].id
                                    viewModel.isShowmovieDetail = true
                                }
                                .onAppear() {
                                    self.loadMoreIfNeeded(currentItem: index)
                                }
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .defaultPage()
        .navigationDestination(isPresented: $viewModel.isShowmovieDetail) {
            MovieDetails(viewModel: MovieDetailViewModel(movieId: viewModel.selectedMovieId))
        }
    }
    
    func loadMoreIfNeeded(currentItem: Int) {
        guard !viewModel.isLoading, currentItem == viewModel.mediaItem.count - 5 else { return }
        viewModel.manageAPIs()
    }
}

#Preview {
    CategoryListScreen(viewModel: CategoryListViewModel())
}
