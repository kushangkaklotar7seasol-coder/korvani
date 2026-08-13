//
//  KorvaniApp.swift
//  Korvani
//
//  Created by Kushang kaklotar on 09/07/26.
//

import SwiftUI
import Combine
import AWSCore
import FirebaseCore
import FirebaseCrashlytics

final class AdState {
    static let shared = AdState()
    
    var isShowingInterstitial = false
}
@main
struct KorvaniApp: App {
    @StateObject private var localization = LocalizationManager.shared
    let adCountViewModel = AdCountViewModel.sharedd
    @Environment(\.scenePhase) private var scenePhase
    @State private var wasInBackground = false
    @State private var showSplashView = false
    
    init() {
        FirebaseApp.configure()
        FirebaseApp.debugDescription()
        Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(true)
        Crashlytics.crashlytics().log("App Launched")
        
        FirebaseConfiguration.shared.setLoggerLevel(FirebaseLoggerLevel.min)
        
        UINavigationBar.appearance().isHidden = true
    }
    
    var body: some Scene {
        WindowGroup {
            if showSplashView {
                NavigationStack {
                    Splash()
                        .navigationBarHidden(true)
                        .toolbar(.hidden, for: .navigationBar)
                        .preferredColorScheme(.dark)
                }
                .environment(\.locale, Locale(identifier: localization.selectedLanguage))
                .environmentObject(localization)
                .environmentObject(adCountViewModel)
                .toastManager()
            }  else {
                SplashConetentView()
                    .preferredColorScheme(.dark)
                    .onAppear {
                        requestTrackingPermission()
                    }
            }
        }
        .onChange(of: scenePhase) { newPhase in
                    switch newPhase {
                        
                    case .background:
                        print("APP IS IN BACKGROUND")
                        wasInBackground = true
                    case .inactive:
                        print("APP IS IN ACTIVE")
                        break
                    case .active:
                        print("APP IS AVTIVE")
                        guard wasInBackground else {
                            print("🚫 Not from background → skip AppOpen")
                            return
                        }
                        
                        wasInBackground = false
                        
                        if isPro {
                            return
                        }
                        
                        if AdState.shared.isShowingInterstitial {
                            print("⛔ Interstitial running → skip AppOpen")
                            return
                        }
                        
                        let hasLaunchedBefore = UserDefaults.standard.bool(forKey: isFirstLaunchKey)
                        
                        if !hasLaunchedBefore {
                            print("🚀 Fresh Install detected - Running first launch Ad logic")
                            
                            if AppOpenAdManager.shared.isShowingAd {
                                return
                            }
                            
                            AppOpenAdManager.shared.resetForForeground()
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                Task {
                                    await AppOpenAdManager.shared.loadAd()
                                    
                                    AppOpenAdManager.shared.showAdIfAvailable()
                                }
                            }
                        } else {
                            if AppOpenBackAdManager.shared.isShowingAd {
                                return
                            }
                            
                            AppOpenBackAdManager.shared.resetForForeground()
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                Task {
                                    await AppOpenBackAdManager.shared.loadAd()
                                    
                                    AppOpenBackAdManager.shared.showAdIfAvailable()
                                }
                            }
                        }
                    @unknown default:
                        break
                    }
                }
    }
    
    
    func requestTrackingPermission() {
            
            UserDefaults.standard.set(true, forKey: userdefaultKey.hasShownConsent)
            
            let credentials = AWSStaticCredentialsProvider(accessKey: ACCESS, secretKey: SECRET)
            let configuration = AWSServiceConfiguration(region: AWSRegionType.EUWest1, credentialsProvider: credentials)
            AWSServiceManager.default().defaultServiceConfiguration = configuration
            
            AdsManager.shared.requestForConsentForm { _ in
                DispatchQueue.main.async{
                    showSplashView = true
                }
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

//extension UINavigationController: @retroactive UIGestureRecognizerDelegate {
//    
//    override open func viewDidLoad() {
//        super.viewDidLoad()
//        interactivePopGestureRecognizer?.delegate = self
//    }
//    
//    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//        guard SwipeBackManager.shared.isEnabled else { return false }
//        return viewControllers.count > 1
//    }
//}

extension View {
    func swipeBackEnabled(_ enabled: Bool) -> some View {
        self.modifier(SwipeBackControl(isEnabled: enabled))
    }
}

struct SwipeBackControl: ViewModifier {
    let isEnabled: Bool

    func body(content: Content) -> some View {
        content
            .onAppear {
                ApplicationState.shared.swipeEnabled = isEnabled
            }
            .onChange(of: isEnabled) { _, newValue in
                ApplicationState.shared.swipeEnabled = newValue
            }
            .onDisappear {
                ApplicationState.shared.swipeEnabled = true
            }
    }
}

import Foundation
import SwiftUI
import Combine

@MainActor
final class ApplicationState: ObservableObject {
    var swipeEnabled: Bool = true

    static let shared = ApplicationState()
//    @Published var introCompleted: Bool {
//        didSet {
//            AppStorageService.shared.set(introCompleted, forKey: .introCompleted)
//        }
//    }
//
//    @Published var languageConfigured: Bool {
//        didSet {
//            AppStorageService.shared.set(languageConfigured, forKey: .langCompleted)
//        }
//    }

    @Published var isDisplayingSplash: Bool = true

//    init() {
//        self.introCompleted = AppStorageService.shared.bool(forKey: .introCompleted)
//        self.languageConfigured = AppStorageService.shared.bool(forKey: .langCompleted)
//    }
}

// MARK: - Interactive Pop Gesture Enabler
extension UINavigationController: UIGestureRecognizerDelegate {

    open override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        // Swipe allowed only if enabled AND more than 1 screen in stack
        return ApplicationState.shared.swipeEnabled && viewControllers.count > 1
    }
}
