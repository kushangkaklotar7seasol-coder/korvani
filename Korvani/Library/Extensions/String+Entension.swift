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
}
