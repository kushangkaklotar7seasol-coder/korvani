//
//  PosterDetailsViewModel.swift
//  Korvani
//
//  Created by Kushang kaklotar on 17/07/26.
//

import Foundation
import Combine

class PosterDetailsViewModel: ObservableObject {
    @Published var images: [MovieImage] = []
    
    init(images: [MovieImage] = []) {
        self.images = images
    }
}
