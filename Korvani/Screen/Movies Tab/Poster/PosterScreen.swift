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
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ZStack {
            VStack {
                DefaultDesign.Header(name: viewModel.isImage ?? true ? Strings.poster : Strings.videos, back: {
                    self.dismiss()
                })
                
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: columns) {
                        if viewModel.isImage ?? true  {
                            ForEach(viewModel.images.indices, id: \.self) { index in
                                let image = viewModel.images[index]
                                MovieDetailsDesign.PosterMedia(isImage: true, image: image.filePath)
                                    .onTapGesture {
                                        viewModel.posterIndex = index
                                        viewModel.isShowPosterDetail = true
                                    }
                            }
                        } else {
                            ForEach(viewModel.video, id: \.key) { video in
                                MovieDetailsDesign.PosterMedia(isImage: false, image: video.key)
                                    .onTapGesture {
                                        if isYoutubeEnabled {
                                            viewModel.youtubeUrl = "https://www.youtube.com/watch?v=\(video.key)"
                                            viewModel.isYoutubeVideo = true
                                        }
                                    }
                            }
                        }
                    }
                }
                
                Spacer()
            }
        }
        .padding(.horizontal, 16)
        .defaultPage()
        .edgesIgnoringSafeArea(.bottom)
        .navigationDestination(isPresented: $viewModel.isShowPosterDetail) {
            PosterDetailScreen(viewModel: PosterDetailsViewModel(images: viewModel.images), position: viewModel.posterIndex)
        }
        .onAppear {
            SwipeBackManager.shared.isEnabled = true
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
