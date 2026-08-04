//
//  AllMoviesScreen.swift
//  Korvani
//
//  Created by Kushang kaklotar on 03/08/26.
//

import SwiftUI

struct AllMoviesScreen: View {
    @Environment(\.dismiss) private var dismiss
    @State private var refreshID = UUID()
    @State var isShowmovieDetail = false
    var header: String = ""
    @State var mediaItem: [MediaItem] = []
    @State var selectedMovie: MediaItem?
    @EnvironmentObject var adVm: AdCountViewModel
    
    var columns: [GridItem] {
            let count = isiPad ? (Device.isiPadLandscape ? 5 : 4) : 2
            return Array(repeating: GridItem(.flexible()), count: count)
        }
    
    var body: some View {
        ZStack {
            VStack {
                DefaultDesign.Header(name: header, back:  {
                    self.dismiss()
                })
                .padding(.horizontal, 16)
                
                ScrollView(showsIndicators: false) {
                    if isShowAdd() {
                        NativeAd9()
                    }
                    
                    if !mediaItem.isEmpty {
                        LazyVGrid(columns: columns) {
                            ForEach(mediaItem.indices, id: \.self) { index in
                                MovieDetail.card(movies: mediaItem[index], numbersOfCard: isiPad ? 4 : 2)
                                    .onTapGesture {
                                        selectedMovie = mediaItem[index]
                                        isShowmovieDetail = true
                                        adVm.registerTap()
                                    }
                            }
                        }
                        .padding(.horizontal, 16)
                        .id(refreshID)
                    } else {
                        Spacer()
                        Text("No Media Found")
                            .font(.system(size: 21, weight: .semibold))
                            .foregroundColor(.whiteColour)
                        Spacer()
                    }
                }
            }
        }
        .defaultPage()
        .navigationDestination(isPresented: $isShowmovieDetail) {
            MovieDetails(viewModel: MovieDetailViewModel(movieId: selectedMovie?.id ?? 0, isMovie: selectedMovie?.title != nil ? true : false))
        }
        .onAppear {
            SwipeBackManager.shared.isEnabled = true
        }
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) {_ in
            refreshID = UUID()
        }
    }
}

#Preview {
    AllMoviesScreen()
}
