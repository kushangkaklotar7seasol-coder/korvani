//
//  InlineAdaptiveBannerView.swift
//  Screen Mirroring Casting
//
//  Created by Parthiv Akbari on 18/05/26.
//

import SwiftUI
import GoogleMobileAds
import Combine

final class BannerAdManager: NSObject, ObservableObject, BannerViewDelegate {
    
    static let shared = BannerAdManager()
    
//    @AppStorage(SessionKeys.isPro) var isPro = false
    @Published var isAdLoaded = false
    
    var bannerView: BannerView?
    
    override init() {
        super.init()
    }
    
    // MARK: - Load Banner
    
    func loadBanner() {
        
        guard isPro == false else {
            print("✅ User is Pro. Banner hidden.")
            isAdLoaded = false
            return
        }
        
        guard bannerId != "" else {
            print("❌ Banner ID empty.")
            isAdLoaded = false
            return
        }
        
        guard let rootVC = UIApplication.topViewController else {
            print("❌ RootViewController not found.")
            return
        }
        
        print("🚀 Loading Banner Ad...")
        
        let screenWidth = UIScreen.main.bounds.width
        
        let adaptiveSize = currentOrientationAnchoredAdaptiveBanner(
            width: screenWidth
        )
        
        let banner = BannerView(adSize: adaptiveSize)
        
        banner.adUnitID = bannerId
        banner.rootViewController = rootVC
        banner.delegate = self
        
        let request = Request()
        
        banner.load(request)
        
        self.bannerView = banner
    }
    
    // MARK: - Banner Delegate
    
    func bannerViewDidReceiveAd(_ bannerView: BannerView) {
        
        print("✅ Banner loaded successfully.")
        
        self.bannerView = bannerView
        
        DispatchQueue.main.async {
            self.isAdLoaded = true
        }
    }
    
    func bannerView(_ bannerView: BannerView,
                    didFailToReceiveAdWithError error: Error) {
        
        print("❌ Banner failed: \(error.localizedDescription)")
        
        DispatchQueue.main.async {
            self.isAdLoaded = false
        }
    }
}
