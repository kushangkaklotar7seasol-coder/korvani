//
//  Global.swift
//  Korvani
//
//  Created by Kushang kaklotar on 09/07/26.
//

import Foundation
import UIKit

let appName = "Korvani"

let screenSize: CGRect = UIScreen.main.bounds

// Extract width and height
let screenWidth = screenSize.width
let screenHeight = screenSize.height

let isAppInTestMode = true

let imageUrl = "https://image.tmdb.org/t/p/w600_and_h900_face"

// MARK: - Supporting class
let locationManager = LocationManager()

let database = SQLiteManager.shared

final class SwipeBackManager {
    static let shared = SwipeBackManager()
    var isEnabled: Bool = true
    private init() {}
}
