//
//  String+Entension.swift
//  Korvani
//
//  Created by Kushang kaklotar on 10/07/26.
//

import Foundation

extension String {
    func localized() -> String {
        let loc = UserdefaultManager.shared.getLanguage()?.code ?? "en"
        let path = Bundle.main.path(forResource: loc, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }

    func localizedLan(loc: String) -> String {
        let path = Bundle.main.path(forResource: "en", ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}

class Strings {
    static var next: String { "NEXT".localized() }
    static var gotIt: String { "GOT_IT".localized() }
    
    static var splashSubtitle: String { "SPLASH_SUBTITLE".localized() }
    
    static var page1Title: String { "PAGE1_TITLE".localized() }
    static var page1Info: String { "PAGE1_INFO".localized() }
    static var page2Title: String { "PAGE2_TITLE".localized() }
    static var page2Info: String { "PAGE2_INFO".localized() }
    static var page3Title: String { "PAGE3_TITLE".localized() }
    static var page3Info: String { "PAGE3_INFO".localized() }
    static var page4Title: String { "PAGE4_TITLE".localized() }
    static var page4Info: String { "PAGE4_INFO".localized() }
    static var infoOnly: String { "INFO_ONLY".localized() }
    static var page4MoreInfo: String { "PAGE4_MOREINFO".localized() }
    
    // MARK: - Home -
    static var welcome: String { "WELCOME".localized() }
    static var smartHub: String { "SMART_HUB".localized() }
    static var appPermissionNotGive: String { "APP_PERMISSION_NOT_GIV".localized() }
    static var unitConverter: String { "UNIT_CONVERTER".localized() }
    static var unitConverterTagline: String { "UNIT_CONVERTER_TAGLINE".localized() }
    static var translate: String { "TRANSLATE".localized() }
    static var translateTagline: String { "TRANSLATE_TAGLINE".localized() }
    static var wallpapers: String { "WALLPAPERS".localized() }
    static var wallpapersTagline: String { "WALLPAPERS_TAGLINE".localized() }
    static var aboutCelebrity: String { "ABOUT_CELEBRITY".localized() }
    static var viewAll: String { "VIEW_ALL".localized() }
    
    // MARK: - Search -
    static var searchPlaceHolder: String { "SEARCH_PLACEHOLDER".localized() }
    static var movies: String { "MOVIES".localized() }
    static var series: String { "SERIES".localized() }
    
    // MARK: - Weather -
    static var weather: String { "WEATHER".localized() }
    static var maximum: String { "MAXIMUM".localized() }
    static var humidity: String { "HUMIDITY".localized() }
    static var wind: String { "WIND".localized() }
    static var forecast: String { "FORECAST".localized() }
    
    // MARK: - Unit Converter -
    static var meters: String { "METERS".localized() }
    static var kilometers: String { "KILOMETERS".localized() }
    static var centimeters: String { "CENTIMETERS".localized() }
    static var millimeters: String { "MILLIMETERS".localized() }
    static var feet: String { "FEET".localized() }
    static var inches: String { "INCHES".localized() }
    static var miles: String { "MILES".localized() }
    static var yards: String { "YARDS".localized() }
    static var kilograms: String { "KILOGRAMS".localized() }
    static var grams: String { "GRAMS".localized() }
    static var miligrams: String { "MILIGRAMS".localized() }
    static var pounds: String { "POUNDS".localized() }
    static var ounces: String { "OUNCES".localized() }
    static var tonnes: String { "TONNES".localized() }
    static var stone: String { "STONE".localized() }
    static var mPerS: String { "M/S".localized() }
    static var kmPerH: String { "KM/H".localized() }
    static var mph: String { "MPH".localized() }
    static var knots: String { "KNOTS".localized() }
    static var ftPerS: String { "FT/S".localized() }
    static var bytes: String { "BYTES".localized() }
    static var kb: String { "KB".localized() }
    static var mb: String { "MB".localized() }
    static var gb: String { "GB".localized() }
    static var tb: String { "TB".localized() }
    static var pb: String { "PB".localized() }
    static var length: String { "LENGTH".localized() }
    static var weight: String { "WEIGHT".localized() }
    static var speed: String { "SPEED".localized() }
    static var storage: String { "STORAGE".localized() }
    
    // MARK: - Translate -
    static var sourceText: String { "SOURCE_TEXT".localized() }
    static var sourcePlaceholder: String { "SOURCE_PLACEHOLDER".localized() }
    static var translationPlaceholder: String { "TRANSLATION_PLACEHOLDER".localized() }
    
    // MARK: - Discover -
    static var newReleases: String { "NEW_RELEASE".localized() }
    static var topRated: String { "TOP_RATED".localized() }
    static var mostPopular: String { "MOST_POPULAR".localized() }
    static var arrivingToday: String { "ARRIVING_TODAY".localized() }
    
    // MARK: - Favorite -
    static var favourite: String { "FAVORITE".localized() }
    static var noFavourite: String { "NO_FAVORITE".localized() }
    static var noFavouriteMovie: String { "NO_MOVIE_TAGLINE".localized() }
    static var noFavouriteSeries: String { "NO_SERIES_TAGLINE".localized() }
    
    // MARK: - Movie Detail -
    static var overview: String { "OVERVIEW".localized() }
    static var showLess: String { "SHOW_LESS".localized() }
    static var showMore: String { "SHOW_MORE".localized() }
    static var moreInfo: String { "MORE_INFO".localized() }
    static var topCast: String { "TOP_CAST".localized() }
    static var coreCrew: String { "CORE_CREW".localized() }
    static var status: String { "STATUS".localized() }
    static var language: String { "LANGUAGE".localized() }
    static var runtime: String { "RUNTIME".localized() }
    static var revenue: String { "REVENUE".localized() }
    static var season: String { "SEASON".localized() }
    static var noCast: String { "NO_CAST".localized() }
    static var noCrew: String { "NO_CREW".localized() }
    static var poster: String { "POSTER".localized() }
    static var videos: String { "VIDEOS".localized() }
    static var noPhotos: String { "NO_PHOTOS".localized() }
    static var noVideo: String { "NO_VIDEO".localized() }
    
    // MARK: - Celebrity Screen
    static var biography: String { "BIOGRAPHY".localized() }
    static var personalInfo: String { "PERSONAL_INFO".localized() }
    static var noMedia: String { "NO_MEDIA".localized() }
    static var birthday: String { "BIRTHDAY".localized() }
    static var age: String { "AGE".localized() }
    static var birthplace: String { "BIRTHPLACE".localized() }
    static var department: String { "DEPARTMENT".localized() }
    
    // MARK: - Puzzle -
    static var puzzle: String { "PUZZLE".localized() }
    static var completed: String { "COMPLETED".localized() }
    static var pieces: String { "PIECES".localized() }
    static var originalPoster: String { "ORIGINAL_POSTER".localized() }
    static var originalPosterTagline: String { "ORIGINAL_IMAGE_TAGLINE".localized() }
    static var puzzleNotes: String { "PUZZLE_NOTES".localized() }
    static var congratulation: String { "CONGRATULATION".localized() }
    static var ok: String { "OK".localized() }
    static var puzzleInstraction: String { "PUZZLE_INSTRACTION".localized() }
    static var puzzleNote1: String { "PUZZLE_NOTE1".localized() }
    static var puzzleNote2: String { "PUZZLE_NOTE2".localized() }
    static var puzzleNote3: String { "PUZZLE_NOTE3".localized() }
    
    // MARK: - Sttting -
    static var setting: String { "SETTING".localized() }
    static var prefrences: String { "PREFERENCES".localized() }
    static var supportInfo: String { "SUPPORT_INFO".localized() }
    static var shareApp: String { "SHARE_APP".localized() }
    static var rateus: String { "RATE_US".localized() }
    static var privecyPolicy: String { "PRIVECY_POLICY".localized() }
    static var termsUse: String { "TEMS_USE".localized() }
    
    // MARK: - Wallpaper Expose Screen -
    static var export: String { "EXPORT".localized() }
    static var downloading: String { "DOWNLOADING".localized() }
    static var downloadSuccess: String { "DOWNLOAD_SUCCESS".localized() }
    static var checkPhotosApp: String { "CHECK_PHOTO_APP".localized() }
    
    // MARK: - Language Screen -
    static var changeLanguage: String { "CHUSE_LANGUAGE".localized() }
    static var done: String { "DONE".localized() }
}
