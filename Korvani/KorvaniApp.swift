//
//  KorvaniApp.swift
//  Korvani
//
//  Created by Kushang kaklotar on 09/07/26.
//

import SwiftUI
internal import Combine

@main
struct KorvaniApp: App {
    @StateObject private var localization = LocalizationManager.shared
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                Splash()
                    .toolbar(.hidden, for: .navigationBar)
                    .preferredColorScheme(.light)
            }
            .environment(\.locale, Locale(identifier: localization.selectedLanguage))
            .environmentObject(localization)
            .id(localization.selectedLanguage)
        }
    }
}

class LocalizationManager: ObservableObject {
    static let shared = LocalizationManager()
    
    @AppStorage("selectedLanguage") var selectedLanguage: String = (UserdefaultManager.shared.getLanguage()?.code ?? "en")
}
