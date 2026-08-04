////
////  InterstialAdManager.swift
////  MovieBox
////
////  Created by Parthiv Akbari on 19/03/26.
////
//
//import Foundation
//import GoogleMobileAds
//import SwiftUI
//import Combine
//
//final class InterstitialAdManager: NSObject, ObservableObject, FullScreenContentDelegate {
////    @AppStorage(SessionKeys.interAdId) var interAdId = ""
//    // MARK: - Published Properties
////    @Published var adUnitID: String = ""
//
//    // MARK: - Private Properties
//    private var interstitial: InterstitialAd?
//    private var isLoading: Bool = false
//
//    // MARK: - Initialization
//    override init() {
//        super.init()
//    }
//    func update(){
//        load()
//    }
//
//    func load() {
//        guard !isLoading else {
//            print("⚙️ [AdManager] Already loading an interstitial, skipping duplicate request.")
//            return
//        }
//
//        isLoading = true
//
//        let request = Request()
//        print("📡 [AdManager] Loading interstitial ad for unit ID: \(interstialId)")
//
//        InterstitialAd.load(with: interstialId, request: request) {  ad, error in
//            self.isLoading = false
//
//            if let error {
//                print("❌ [AdManager] Failed to load interstitial: \(error.localizedDescription)")
//                return
//            }
//
//            self.interstitial = ad
//            self.interstitial?.fullScreenContentDelegate = self
//            print("✅ [AdManager] Interstitial loaded successfully for ID: \(interstialId)")
//        }
//    }
//
//    /// Presents the interstitial ad if available; otherwise reloads.
//    func present() {
//        guard let root = UIApplication.shared.firstKeyWindowRootViewController() else {
//            print("⚠️ [AdManager] No rootViewController found for presentation.")
//            return
//        }
//
//        guard let interstitial else {
//            print("⚠️ [AdManager] Ad not ready, attempting reload.")
//            load()
//            return
//        }
//
//        print("🎬 [AdManager] Presenting interstitial ad.")
//        interstitial.present(from: root)
//    }
//
//    // MARK: - GADFullScreenContentDelegate
//
//    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
//        print("ℹ️ [AdManager] Interstitial dismissed. Preparing next ad.")
//        interstitial = nil
//        load()
//    }
//
//    func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
//        print("❌ [AdManager] Failed to present interstitial: \(error.localizedDescription)")
//        interstitial = nil
//        load()
//    }
//
//    func adDidRecordImpression(_ ad: FullScreenPresentingAd) {
//        print("👁️ [AdManager] Interstitial impression recorded.")
//    }
//
//    func adDidRecordClick(_ ad: FullScreenPresentingAd) {
//        print("🖱️ [AdManager] Interstitial clicked.")
//    }
//}
//
//// Helper to locate a root view controller for presentation in multi-scene apps.
//private extension UIApplication {
//    func firstKeyWindowRootViewController() -> UIViewController? {
//        connectedScenes
//            .compactMap { ($0 as? UIWindowScene)?.keyWindow } // Iterate active scenes and find the key window
//            .first?
//            .rootViewController
//    }
//}
//
//// Convenience to fetch the key window for a scene
//private extension UIWindowScene {
//    var keyWindow: UIWindow? { windows.first(where: { $0.isKeyWindow }) }
//}
//



import Foundation
import GoogleMobileAds
import SwiftUI
import Combine
 
final class InterstitialAdManager: NSObject, ObservableObject, FullScreenContentDelegate {
    //    @AppStorage(SessionKeys.interAdId) var interAdId = ""
    
    // MARK: - Private Properties
    private var interstitial: InterstitialAd?
    private var isLoading: Bool = false
    private var onDismiss: (() -> Void)?
    
    // MARK: - Initialization
    override init() {
        //        interAdId = AppConfig.interstialId
        super.init()
    }
    func update(){
        //        interAdId = AppConfig.interstialId
        load()
    }
    
    func load() {
        guard !isLoading else {
            print("⚙️ [AdManager] Already loading an interstitial, skipping duplicate request.")
            return
        }
        
        isLoading = true
        
        let request = Request()
        print("📡 [AdManager] Loading interstitial ad for unit ID: \(interstialId)")
        
        InterstitialAd.load(with: interstialId, request: request) {  ad, error in
            self.isLoading = false
            
            if let error {
                print("❌ [AdManager] Failed to load interstitial: \(error.localizedDescription)")
                return
            }
            
            self.interstitial = ad
            self.interstitial?.fullScreenContentDelegate = self
            print("✅ [AdManager] Interstitial loaded successfully for ID: \(interstialId)")
        }
    }
    
    func present(onDismiss: (() -> Void)? = nil) {
        guard let root = UIApplication.shared.firstKeyWindowRootViewController() else {
            print("⚠️ [AdManager] No rootViewController found for presentation.")
            onDismiss?()
            return
        }
        
        guard let interstitial else {
            print("⚠️ [AdManager] Ad not ready, attempting reload.")
            load()
            onDismiss?()
            return
        }
        
        sholdShowAppOpenAd = false
        print("🎬 [AdManager] Presenting interstitial ad.")
        self.onDismiss = onDismiss
        interstitial.present(from: root)
    }
    
    // MARK: - GADFullScreenContentDelegate
    
    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        print("ℹ️ [AdManager] Interstitial dismissed. Preparing next ad.")
        interstitial = nil
        load()
        onDismiss?()
        onDismiss = nil
        sholdShowAppOpenAd = true
    }
    
    func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("❌ [AdManager] Failed to present interstitial: \(error.localizedDescription)")
        interstitial = nil
        load()
        onDismiss?()
        onDismiss = nil
        sholdShowAppOpenAd = true
    }
    
    func adDidRecordImpression(_ ad: FullScreenPresentingAd) {
        print("👁️ [AdManager] Interstitial impression recorded.")
    }
    
    func adDidRecordClick(_ ad: FullScreenPresentingAd) {
        print("🖱️ [AdManager] Interstitial clicked.")
    }
}
 
private extension UIApplication {
    func firstKeyWindowRootViewController() -> UIViewController? {
        connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first?
            .rootViewController
    }
}
 
private extension UIWindowScene {
    var keyWindow: UIWindow? { windows.first(where: { $0.isKeyWindow }) }
}
 
 

