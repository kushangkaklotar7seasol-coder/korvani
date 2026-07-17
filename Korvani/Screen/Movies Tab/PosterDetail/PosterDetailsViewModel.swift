//
//  PosterDetailsViewModel.swift
//  Korvani
//
//  Created by Kushang kaklotar on 17/07/26.
//

import Foundation
internal import Combine

class PosterDetailsViewModel: ObservableObject {
    @Published var images: [MovieImage] = []
    
    init(images: [MovieImage] = []) {
        self.images = images
    }
}
