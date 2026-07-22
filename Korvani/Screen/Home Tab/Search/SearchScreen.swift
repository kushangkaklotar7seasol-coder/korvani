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
                        Utility.closeKeyboard()
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
                        
                        TextField(Strings.searchPlaceHolder, text: $viewModel.searchTextField)
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
                
                CustomSegmentedControl(preselectedIndex: $viewModel.selectedIndex, options: [Strings.movies, Strings.series]) { index in
                    viewModel.manageAPICalls(index: index)
                }
                
                let array = viewModel.selectedIndex == 0 ? viewModel.movies : viewModel.series
                
                if !array.isEmpty {
                    
                    VStack {
                        if viewModel.selectedIndex == 0 {
                            ScrollView(showsIndicators: false) {
                                
                                LazyVGrid(columns: columns) {
                                    ForEach(array.indices, id: \.self) { index in
                                        MovieDetail.card(movies: array[index])
                                            .onTapGesture {
                                                Utility.closeKeyboard()
                                                viewModel.selectedMovie = array[index]
                                                viewModel.isShowmovieDetail = true
                                            }
                                            .onAppear() {
                                                self.loadMoreIfNeeded(currentItem: index)
                                            }
                                    }
                                }
                                .padding(.vertical, 20)
                                
                            }
                            .scrollDismissesKeyboard(.immediately)
                        } else {
                            ScrollView(showsIndicators: false) {
                                
                                LazyVGrid(columns: columns) {
                                    ForEach(array.indices, id: \.self) { index in
                                        MovieDetail.card(movies: array[index])
                                            .onTapGesture {
                                                Utility.closeKeyboard()
                                                viewModel.selectedMovie = array[index]
                                                viewModel.isShowmovieDetail = true
                                            }
                                            .onAppear() {
                                                self.loadMoreIfNeeded(currentItem: index)
                                            }
                                    }
                                }
                                .padding(.vertical, 20)
                                
                            }
                            .scrollDismissesKeyboard(.immediately)
                            
                        }
                    }
                    
                } else {
//                    VStack {
//                        Spacer()
//                        
//                        if viewModel.searchTextField.isEmpty {
//                            Text("Try To Search Movies or Series")
//                                .font(.system(size: 21, weight: .semibold))
//                                .foregroundColor(.whiteColour)
//                        } else {
//                            Text("No data found for \(viewModel.searchTextField)")
//                                .font(.system(size: 21, weight: .semibold))
//                                .foregroundColor(.whiteColour)
//                        }
//                        
//                        Spacer()
//                    }
                    VStack {
                        VStack(spacing: 16) {
                            if viewModel.searchTextField.isEmpty {
                                
                                Image("ic_search_empty_background")
                                    .resizable()
                                    .frame(width: 120, height: 120, alignment: .center)
                                
                                Text(Strings.searchMoviePlaceholder)
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.whiteColour)
                                    .multilineTextAlignment(.center)
                                
                                Text(Strings.newSearchPlaceholder)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.grayColour)
                                    .multilineTextAlignment(.center)
                                
                            } else {
                                Image("ic_search_empty_background")
                                    .resizable()
                                    .frame(width: 120, height: 120, alignment: .center)
                                
                                Text(Strings.noSearchData)
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.whiteColour)
                                    .multilineTextAlignment(.center)
                                
                                Text("\(Strings.noSearchDataFor) \(viewModel.searchTextField)")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.grayColour)
                                    .multilineTextAlignment(.center)
                            }
                            
                        }
                        .opacity(0.4)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .offset(y: -viewModel.keyboardHeight / 3 - 64)
                    }
                    .frame(maxWidth: .infinity)
                }
                
                Spacer()
            }
            .edgesIgnoringSafeArea(.bottom)
        }
        .padding(.horizontal, 16)
//        .padding(.bottom, viewModel.isKeyboardVisible ? viewModel.keyboardHeight : 0)
//        .animation(.easeOut(duration: 0.25), value: viewModel.keyboardHeight)
        .defaultPage()
        .edgesIgnoringSafeArea(.bottom)
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onTapGesture {
            isTextFieldFocused = false
        }
        .navigationDestination(isPresented: $viewModel.isShowmovieDetail) {
            MovieDetails(viewModel: MovieDetailViewModel(movieId: viewModel.selectedMovie?.id ?? 0, isMovie: viewModel.selectedMovie?.title != nil ? true : false))
        }
        .onAppear {
            SwipeBackManager.shared.isEnabled = true
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { notification in
                    if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                        withAnimation(.easeOut(duration: 0.25)) {
                            viewModel.keyboardHeight = keyboardFrame.height
                        }
                    }
                }
                .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                    withAnimation(.easeOut(duration: 0.25)) {
                        viewModel.keyboardHeight = 0
                    }
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
