//
//  PosterScreen.swift
//  Korvani
//
//  Created by Kushang kaklotar on 17/07/26.
//

import SwiftUI

struct PosterScreen: View {
    @Environment(\.dismiss) public var dismiss
    @StateObject var viewModel: PosterViewModel
    @State var refreshID = UUID()
//    private let columns = [
//        GridItem(.flexible()),
//        GridItem(.flexible())
//    ]
//    @State private var refreshID = UUID()
//    @EnvironmentObject var orientation: OrientationObserver
    var columns: [GridItem] {
            let count = isiPad ? (Device.isiPadLandscape ? 4 : 3) : 2
            return Array(repeating: GridItem(.flexible(), spacing: 15), count: count)
        }
    @EnvironmentObject var adVm: AdCountViewModel
    
    var body: some View {
        ZStack {
            VStack {
                DefaultDesign.Header(name: viewModel.isImage ?? true ? Strings.poster : Strings.videos, back: {
                    self.dismiss()
                })
                .padding(.horizontal, 16)
                
                ScrollView(showsIndicators: false) {
                    if isShowAdd() {
                        NativeAd9()
                    }
                    
                    LazyVGrid(columns: columns) {
                        if viewModel.isImage ?? true  {
                            ForEach(viewModel.images.indices, id: \.self) { index in
                                let image = viewModel.images[index]
                                MovieDetailsDesign.PosterMedia(isImage: true, image: image.filePath)
                                    .onTapGesture {
                                        viewModel.posterIndex = index
                                        viewModel.isShowPosterDetail = true
                                        adVm.registerTap()
                                        logAnalyticAction(title: "", status: AnalyticEvent.Poster)
                                    }
                            }
                        } else {
                            ForEach(viewModel.video, id: \.key) { video in
                                MovieDetailsDesign.PosterMedia(isImage: false, image: video.key)
                                    .onTapGesture {
                                        if isYoutubeEnabled {
                                            viewModel.youtubeUrl = "https://www.youtube.com/watch?v=\(video.key)"
                                            if isPremiumRequiredForYT {
                                                if isPro {
                                                    viewModel.isYoutubeVideo = true
                                                } else {
                                                    viewModel.isshowPremium = true
                                                    logAnalyticAction(title: "", status: AnalyticEvent.Poster)
                                                }
                                                
                                            } else {
                                                viewModel.isYoutubeVideo = true
                                            }

                                        }
                                    }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .id(refreshID)
                }
                
                Spacer()
            }
        }
        
        .defaultPage()
        .edgesIgnoringSafeArea(.bottom)
        .navigationDestination(isPresented: $viewModel.isShowPosterDetail) {
            PosterDetailScreen(viewModel: PosterDetailsViewModel(images: viewModel.images), position: viewModel.posterIndex)
        }
        .onAppear {
            SwipeBackManager.shared.isEnabled = true
        }
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
            refreshID = UUID()
        }
        .fullScreenCover(isPresented: $viewModel.isshowPremium) {
            PremiumScreen()
        }
        .sheet(isPresented: $viewModel.isYoutubeVideo) {
            NavigationStack {
                WebView(url: URL(string: viewModel.youtubeUrl)!)
//                    .navigationTitle("Browser")
//                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Done") {
                                viewModel.isYoutubeVideo = false
                            }
                        }
                    }
            }
        }
    }
}

#Preview {
    PosterScreen(viewModel: PosterViewModel())
}
