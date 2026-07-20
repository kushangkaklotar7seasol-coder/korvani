//
//  String+Entension.swift
//  Korvani
//
//  Created by Kushang kaklotar on 10/07/26.
//

import Foundation

extension String {
    func localized() -> String {
        let loc = UserdefaultManager.shared.getLanguage()?.code
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
    static let next = "NEXT".localized()
    static let gotIt = "GOT_IT".localized()
    
    static let splashSubtitle = "SPLASH_SUBTITLE".localized()
    
    static let page1Title = "PAGE1_TITLE".localized()
    static let page1Info = "PAGE1_INFO".localized()
    static let page2Title = "PAGE2_TITLE".localized()
    static let page2Info = "PAGE2_INFO".localized()
    static let page3Title = "PAGE3_TITLE".localized()
    static let page3Info = "PAGE3_INFO".localized()
    static let page4Title = "PAGE4_TITLE".localized()
    static let page4Info = "PAGE4_INFO".localized()
    static let infoOnly = "INFO_ONLY".localized()
    static let page4MoreInfo = "PAGE4_MOREINFO".localized()
    
    // MARK: - Home -
    static let welcome = "WELCOME".localized()
    static let smartHub = "SMART_HUB".localized()
    static let appPermissionNotGive = "APP_PERMISSION_NOT_GIV".localized()
    static let unitConverter = "UNIT_CONVERTER".localized()
    static let unitConverterTagline = "UNIT_CONVERTER_TAGLINE".localized()
    static let translate = "TRANSLATE".localized()
    static let translateTagline = "TRANSLATE_TAGLINE".localized()
    static let wallpapers = "WALLPAPERS".localized()
    static let wallpapersTagline = "WALLPAPERS_TAGLINE".localized()
    static let aboutCelebrity = "ABOUT_CELEBRITY".localized()
    static let viewAll = "VIEW_ALL".localized()
    
    // MARK: - Search -
    static let searchPlaceHolder = "SEARCH_PLACEHOLDER".localized()
    static let movies = "MOVIES".localized()
    static let series = "SERIES".localized()
    
    // MARK: - Weather -
    static let weather = "WEATHER".localized()
    static let maximum = "MAXIMUM".localized()
    static let humidity = "HUMIDITY".localized()
    static let wind = "WIND".localized()
    static let forecast = "FORECAST".localized()
    
    // MARK: - Unit Converter -
    static let meters = "METERS".localized()
    static let kilometers = "KILOMETERS".localized()
    static let centimeters = "CENTIMETERS".localized()
    static let millimeters = "MILLIMETERS".localized()
    static let feet = "FEET".localized()
    static let inches = "INCHES".localized()
    static let miles = "MILES".localized()
    static let yards = "YARDS".localized()
    static let kilograms = "KILOGRAMS".localized()
    static let grams = "GRAMS".localized()
    static let miligrams = "MILIGRAMS".localized()
    static let pounds = "POUNDS".localized()
    static let ounces = "OUNCES".localized()
    static let tonnes = "TONNES".localized()
    static let stone = "STONE".localized()
    static let mPerS = "M/S".localized()
    static let kmPerH = "KM/H".localized()
    static let mph = "MPH".localized()
    static let knots = "KNOTS".localized()
    static let ftPerS = "FT/S".localized()
    static let bytes = "BYTES".localized()
    static let kb = "KB".localized()
    static let mb = "MB".localized()
    static let gb = "GB".localized()
    static let tb = "TB".localized()
    static let pb = "PB".localized()
    static let length = "LENGTH".localized()
    static let weight = "WEIGHT".localized()
    static let speed = "SPEED".localized()
    static let storage = "STORAGE".localized()
}
