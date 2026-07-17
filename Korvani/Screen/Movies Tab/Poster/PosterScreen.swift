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
                DefaultDesign.Header(name: viewModel.isImage ?? true ? "Poster" : "Videos", back: {
                    self.dismiss()
                })
                
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: columns) {
                        if viewModel.isImage ?? true  {
                            ForEach(viewModel.images, id: \.filePath) { image in
                                MovieDetailsDesign.PosterMedia(isImage: true, image: image.filePath)
                            }
                        } else {
                            ForEach(viewModel.video, id: \.key) { video in
                                MovieDetailsDesign.PosterMedia(isImage: false, image: video.key)
                                    .onTapGesture {
                                        viewModel.openInYouTubeApp(videoID: video.key)
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
    }
}

#Preview {
    PosterScreen(viewModel: PosterViewModel())
}
