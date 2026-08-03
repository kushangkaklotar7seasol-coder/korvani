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
    @State private var refreshID = UUID()
//    @EnvironmentObject var orientation: OrientationObserver
    
    var cardWidth : CGFloat {
        if isiPad {
            if Device.isiPadLandscape {
                return (screenWidth-47)/5
            } else {
                return (screenWidth-47)/4
            }
        } else {
            return (screenWidth-47)/2
        }
    }
    
//    private let columns = [
//        GridItem(.flexible()),
//        GridItem(.flexible())
//    ]
    
    var columns: [GridItem] {
        let count = isiPad ? (Device.isiPadLandscape ? 5 : 4) : 2
        return Array(repeating: GridItem(.flexible(), spacing: 15), count: count)
        }
    
    
    var body: some View {
        ZStack {
            VStack {
                DefaultDesign.Header(name: "WALLPAPERS", back: {
                    self.dismiss()
                })
                
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: columns) {
                        ForEach(viewModel.displayWallpaper.indices, id: \.self) { index in
                            ZStack {
                                KFImage.url(URL(string: viewModel.displayWallpaper[index].src.medium))
                                    .resizable()
                                    .scaledToFill()
                            }
                            .frame(width: cardWidth , height: cardWidth*1.4)
                            .background(.grayColour.opacity(0.5))
                            .cornerRadius(10)
                            .onAppear() {
                                self.loadMoreIfNeeded(currentItem: index)
                            }
                            .onTapGesture {
                                viewModel.selectedWallpaper = viewModel.displayWallpaper[index]
                                viewModel.isShowDownload = true
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .defaultPage()
        .id(refreshID)
        .navigationDestination(isPresented: $viewModel.isShowDownload) {
            WallpaperExportScreen(viewModel: WallpaperExportViewModel(wallpaper: viewModel.selectedWallpaper))
        }
        .onAppear {
            SwipeBackManager.shared.isEnabled = true
        }
        .onReceive(
            NotificationCenter.default.publisher(
                for: UIDevice.orientationDidChangeNotification
            )
        ) { _ in
            refreshID = UUID()
        }
    }
    
    func loadMoreIfNeeded(currentItem: Int) {
        guard !viewModel.isLoading, currentItem >= viewModel.displayWallpaper.count - 4 else { return }
        
        if !viewModel.isLoading {
            guard viewModel.totalPage >= viewModel.pageCount else {
                print("Limit completed")
                print("\(viewModel.totalPage) Total page")
                print("\(viewModel.pageCount) My page count")
                return
            }
            
            print("LOAD MORE")
            viewModel.wallpaperAPI()
        }
    }
}

#Preview {
    WallpaperScreen()
}
