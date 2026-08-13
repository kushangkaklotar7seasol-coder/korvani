//
//  Global.swift
//  Korvani
//
//  Created by Kushang kaklotar on 09/07/26.
//

import Foundation
import UIKit

let appName = "Pikcube"

let screenSize: CGRect = UIScreen.main.bounds
let isiPad = UIDevice.current.userInterfaceIdiom == .pad
// Extract width and height
var screenWidth: CGFloat {
    return UIScreen.main.bounds.width
}

var screenHeight: CGFloat {
    return UIScreen.main.bounds.height
}

let isAppInTestMode = true
var isIsShowPremiumScreen = true

let puzzleImageUrl = "https://raw.githubusercontent.com/kushangkaklotar7seasol-coder/korvani/refs/heads/main/Images/"
let imageUrl = "https://image.tmdb.org/t/p/w600_and_h900_face"
public let ACCESS = "AKIA2FCATE7MLGSZBHML"
public let SECRET = "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"

// MARK: - Ads manager -
var isPro = false
var bannerId = ""
var nativeId = ""
var appopenId = ""
var rewardId = ""
var interstialId = ""
var addButtonColor = ""
var smallNativeBannerId = ""
var adsCount = 0
var adsPlus = 0
var sholdShowAppOpenAd = true
let isFirstLaunchKey = "isFirstLaunch"

enum userdefaultKey {
    static let hasShownConsent = "hasShownConsent"
}

var isYoutubeEnabled = false
var isShowLifetime = true
var isShowYearlyPlan = true
var isShowWeeklyPlan = true
var isShowMonthlyPlan = true
var isPremiumRequiredForYT = true

var enabledPlanCount: Int {
    [isShowLifetime, isShowYearlyPlan, isShowWeeklyPlan, isShowMonthlyPlan]
        .filter { $0 }
        .count
}

var hasMultiplePlans: Bool {
    enabledPlanCount > 1
}

// MARK: - Supporting class
let locationManager = LocationManager()

let database = SQLiteManager.shared



final class SwipeBackManager {
    static let shared = SwipeBackManager()
    var isEnabled: Bool = true
    private init() {}
}

// MARK: - Default message -

let noInternet = "Please check you're internet connection!"

func isShowAdd() -> Bool {
    return !isPro && (nativeId != "" || nativeId != "ca" )
}

class AppSession {
    static let shared = AppSession()
    
    var hasShownPremium = false
    var hasShownRate = false
}
