//
//  AnalyticsEvent.swift
//  Smart Mirror
//
//  Created by Sahil Gelani on 06/05/26.
//

import Foundation
import FirebaseCore
import FirebaseAnalytics

enum AnalyticEvent: String {
    case Home
    case Discover
    case Setting
    case MovieDetail
    case CastDetail
    case Poster
    case CastCrew
}

func logAnalyticView(title: String, Screen: String) {
    Analytics.logEvent(AnalyticsEventScreenView, parameters: [AnalyticsParameterScreenName: title, AnalyticsParameterScreenClass: Screen])
}

func logAnalyticAction(title: String, status: AnalyticEvent) {
    Analytics.logEvent(status.rawValue, parameters: ["name": title, "status": status])
}

func logAnalyticActionWithParams(_ name: AnalyticEvent, parameters: [String : Any]?){
    Analytics.logEvent(name.rawValue, parameters: parameters)
}
