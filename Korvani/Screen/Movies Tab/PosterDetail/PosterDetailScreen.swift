//
//  PosterDetailScreen.swift
//  Korvani
//
//  Created by Kushang kaklotar on 17/07/26.
//

import SwiftUI
import Kingfisher

struct PosterDetailScreen: View {
    @Environment(\.dismiss) public var dismiss
    var cardWidth: CGFloat { screenWidth * 0.8 }
    @StateObject var viewModel: PosterDetailsViewModel
    @State var scrollPosition: Int?
    @State var position: Int?
    var posterHeight: CGFloat {
        return screenHeight-360
    }
    
    var body: some View {
        ZStack {
            VStack {
                DefaultDesign.Header(name: "Poster", back: {
                    self.dismiss()
                })
                .padding(.horizontal, 16)
                
                Spacer()
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(viewModel.images.indices, id: \.self) { index in
                            VStack(alignment: .leading) {
                                ZStack {
                                    KFImage.url(URL(string: imageUrl + viewModel.images[index].filePath))
                                        .resizable()
                                        .scaledToFill()
                                }
                                .frame(width: cardWidth, height: self.isSelected(index) ? posterHeight : posterHeight-50)
                                .background(.white)
                                .cornerRadius(10)
                                .id(index)
                                .animation(.easeInOut(duration: 0.3), value: scrollPosition)
                            }
                        }
                    }
                    .scrollTargetLayout()
                }
                .safeAreaPadding(.horizontal, (screenWidth - cardWidth) / 2)
                .scrollTargetBehavior(.viewAligned)
                .scrollPosition(id: $scrollPosition)
                .frame(height: posterHeight)

                Spacer()
            }
        }
        .defaultPage()
        .onAppear {
            DispatchQueue.main.async {
                scrollPosition = position
            }
        }
    }
    
    private func isSelected(_ index: Int) -> Bool {
        (scrollPosition ?? 0) == index
    }
}

#Preview {
    PosterDetailScreen(viewModel: PosterDetailsViewModel())
}
