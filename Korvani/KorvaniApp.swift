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
            ZStack {
                NavigationStack {
                    Splash()
                        .navigationBarHidden(true)
                        .toolbar(.hidden, for: .navigationBar)
                        .preferredColorScheme(.dark)
                }
                .environment(\.locale, Locale(identifier: localization.selectedLanguage))
                .environmentObject(localization)
            }
            .toastManager()
        }
    }
}

class LocalizationManager: ObservableObject {
    static let shared = LocalizationManager()
    
    @AppStorage("selectedLanguage") var selectedLanguage: String = (UserdefaultManager.shared.getLanguage()?.code ?? "en") {
        didSet {
            Bundle.setLanguage(selectedLanguage)
        }
    }
    
    init() {
        Bundle.setLanguage(selectedLanguage) // set bundle correctly on cold launch too
    }
    
    func changeLanguage(languageCode: String){
        Bundle.setLanguage(languageCode)
        selectedLanguage = languageCode
    }
}

extension Bundle {
    static var localizedBundle: Bundle = Bundle.main
    
    static func setLanguage(_ language: String) {
        let path = Bundle.main.path(forResource: language, ofType: "lproj")
        localizedBundle = path.flatMap { Bundle(path: $0) } ?? Bundle.main
    }
}

extension UINavigationController: @retroactive UIGestureRecognizerDelegate {
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard SwipeBackManager.shared.isEnabled else { return false }
        return viewControllers.count > 1
    }
}
