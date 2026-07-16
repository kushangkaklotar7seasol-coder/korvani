//
//  WallpaperViewModel.swift
//  Korvani
//
//  Created by Kushang kaklotar on 15/07/26.
//

import Foundation
internal import Combine

class WallpaperViewModel: ObservableObject {
    @Published var pageCount = 0
    @Published var wallpapger: WallpaperListResponse?
    @Published var isLoading = false
    @Published var displayWallpaper: [Wallpaper] = []
    @Published var isShowDownload = false
    @Published var selectedWallpaper: Wallpaper?
    
    init() {
        self.wallpaperAPI()
    }
    
    func wallpaperAPI() {
        if Utility.isInternetAvailable() {
            self.pageCount += 1
            self.isLoading = true
            WallpaperService.shared.wallpaperAPI(page: self.pageCount) { statusCode, response in
                self.isLoading = false
                self.wallpapger?.limit = response.limit
                self.wallpapger?.page = response.page
                self.wallpapger?.totalPages = response.totalPages
                self.wallpapger?.total = response.total
                
                for i in response.data {
                    self.displayWallpaper.append(i)
                }
                
                print(self.displayWallpaper)
            } failure: { error in
                self.isLoading = false
                print(error)
            }
        } else {
            print("No internet connected")
        }
    }
    
}
