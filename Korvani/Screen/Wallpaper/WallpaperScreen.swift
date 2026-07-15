//
//  WallpaperScreen.swift
//  Korvani
//
//  Created by Kushang kaklotar on 15/07/26.
//

import SwiftUI
import Kingfisher

struct WallpaperScreen: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel = WallpaperViewModel()
    var cardWidth = {
        return (screenWidth-47)/2
    }
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ZStack {
            VStack {
                DefaultDesign.Header(name: "HD Wallpaper", back: {
                    self.dismiss()
                })
                
                ScrollView(showsIndicators: false) {
//                   if let array = viewModel.displayWallpaper {
                        LazyVGrid(columns: columns) {
                            ForEach(viewModel.displayWallpaper.indices, id: \.self) { index in
                                ZStack {
                                    KFImage.url(URL(string: viewModel.displayWallpaper[index].src.original))
                                        .resizable()
                                        .scaledToFill()
                                }
                                .frame(width: cardWidth(), height: cardWidth()*1.4)
                                .background(.grayColour.opacity(0.5))
                                .cornerRadius(10)
                                .onAppear() {
                                    loadMoreIfNeeded(currentItem: index)
                                }
                                .onTapGesture {
                                    viewModel.selectedWallpaper = viewModel.displayWallpaper[index]
                                    viewModel.isShowDownload = true
                                }
                            }
                        }
//                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .defaultPage()
        .navigationDestination(isPresented: $viewModel.isShowDownload) {
            WallpaperExportScreen(viewModel: WallpaperExportViewModel(wallpaper: viewModel.selectedWallpaper))
        }
    }
    
    func loadMoreIfNeeded(currentItem: Int) {
        print(currentItem)
        guard !viewModel.isLoading, currentItem == viewModel.displayWallpaper.count - 4 else { return }
        viewModel.wallpaperAPI()
    }
}

#Preview {
    WallpaperScreen()
}
