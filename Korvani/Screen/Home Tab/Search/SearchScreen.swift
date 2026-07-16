//
//  SearchScreen.swift
//  Korvani
//
//  Created by Kushang kaklotar on 15/07/26.
//

import SwiftUI

struct SearchScreen: View {
    @StateObject var viewModel = SearchViewModel()
    @Environment(\.dismiss) private var dismiss
    @FocusState var isTextFieldFocused: Bool
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ZStack {
            VStack(spacing: 5) {
                
                HStack {
                    Button {
                        self.dismiss()
                    } label: {
                        Image("ic_cancel_bg")
                            .resizable()
                            .frame(width: 40, height: 40, alignment: .center)
                    }
                    
                    HStack {
                        Image("ic_search_empty")
                            .resizable()
                            .frame(width: 16, height: 16, alignment: .center)
                            .padding(.leading, 9)
                        
                        TextField("Search Movies & TV Shows", text: $viewModel.searchTextField)
                            .frame(height: 40)
                            .focused($isTextFieldFocused)
                            .overlay(
                                HStack {
                                    Spacer()
                                    if !viewModel.searchTextField.isEmpty {
                                        Button(action: {
                                            self.viewModel.searchTextField = ""
                                            viewModel.movies = []
                                            viewModel.series = []
                                            viewModel.moviesResponse = nil
                                            viewModel.seriesResponse = nil
                                        }) {
                                            Image(systemName: "multiply.circle.fill")
                                                .foregroundColor(.gray)
                                                .padding(.trailing, 8)
                                        }
                                    }
                                }
                            )
                    }
                    .frame(maxWidth: .infinity)
                    .background(.borderColour)
                    .cornerRadius(10)
                }
                .padding(.top, 10)
                
                CustomSegmentedControl(preselectedIndex: $viewModel.selectedIndex, options: ["Movies", "Series"]) { index in
                    viewModel.manageAPICalls(index: index)
                }
                
                ScrollView(showsIndicators: false) {
                    let array = viewModel.selectedIndex == 0 ? viewModel.movies : viewModel.series
                    
                    LazyVGrid(columns: columns) {
                        ForEach(array.indices, id: \.self) { index in
                            MovieDetail.card(movies: array[index])
                                .onAppear() {
                                    self.loadMoreIfNeeded(currentItem: index)
                                }
                        }
                    }
                    .padding(.vertical, 20)
                }
                
//                if viewModel.selectedIndex == 0 {
//                    ScrollView(showsIndicators: false) {
//                        
//                        LazyVGrid(columns: columns) {
//                            ForEach(viewModel.movies.indices, id: \.self) { index in
//                                MovieDetail.card(movies: viewModel.movies[index])
//                            }
//                        }
//                        .padding(.vertical, 20)
//                    }
//                } else {
//                    ScrollView(showsIndicators: false) {
//                        LazyVGrid(columns: columns) {
//                            ForEach(viewModel.series.indices, id: \.self) { index in
//                                MovieDetail.card(movies: viewModel.series[index])
//                            }
//                        }
//                        .padding(.vertical, 20)
//                    }
//                }
                
                Spacer()
            }
        }
        .padding(.horizontal, 16)
        .defaultPage()
        .edgesIgnoringSafeArea(.bottom)
        .onTapGesture {
            isTextFieldFocused = false
        }
    }
    
    func loadMoreIfNeeded(currentItem: Int) {
        if viewModel.selectedIndex == 0 {
            guard !viewModel.isLoading, currentItem == viewModel.movies.count - 5 else { return }
            viewModel.moviesSearchAPI(text: viewModel.searchTextField, isFromPagination: true)
        } else {
            guard !viewModel.isLoading, currentItem == viewModel.series.count - 5 else { return }
            viewModel.searchSeriesAPI(text: viewModel.searchTextField, isFromPagination: true)
        }
    }
}

#Preview {
    SearchScreen()
}
