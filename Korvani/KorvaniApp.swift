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
    
    init() {
        UINavigationBar.appearance().isHidden = true
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ZStack {
                    Splash()
                        .navigationBarHidden(true)
                        .toolbar(.hidden, for: .navigationBar)
                }
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
