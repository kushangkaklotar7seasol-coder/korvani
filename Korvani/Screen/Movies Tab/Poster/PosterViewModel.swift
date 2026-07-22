//
//  PosterViewModel.swift
//  Korvani
//
//  Created by Kushang kaklotar on 17/07/26.
//

import Foundation
internal import Combine
import UIKit

class PosterViewModel : ObservableObject {
    @Published var images: [MovieImage] = []
    @Published var video: [Video] = []
    @Published var posterIndex: Int = 0
    @Published var isShowPosterDetail = false
    
    @Published var isYoutubeVideo = false
    @Published var youtubeUrl = ""
    
    var isImage: Bool?
    
    init(images: [MovieImage] = [], video: [Video] = [], isImage: Bool = true){
        self.images = images
        self.video = video
        self.isImage = isImage
    }
    
    func openInYouTubeApp(videoID: String) {
        if let url = URL(string: "youtube://www.youtube.com/watch?v=\(videoID)") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                if let url = URL(string: "https://www.youtube.com/watch?v=\(videoID)") {
                    UIApplication.shared.open(url)
                }
            }
        }
    }
}
