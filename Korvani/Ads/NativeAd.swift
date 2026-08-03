//
//  NativeAd.swift
//  MovieBox
//
//  Created by Parthiv Akbari on 19/03/26.
//

import Foundation
import SwiftUI
import GoogleMobileAds
import UIKit
import Combine

final class NativeAdViewModel: NSObject, ObservableObject {
    @Published var nativeAd: NativeAd?
    @Published var samllNativeAd: NativeAd?
    @Published var didFailToLoad: Bool = false
    @Published var didFailToLoadSmall: Bool = false

    private var adLoader: AdLoader?
    private var samllAdLoader: AdLoader?

    func refreshAd() {
        didFailToLoad = false
        nativeAd = nil

        let adUnitID = nativeId
        
        let request = Request()
        adLoader = AdLoader(adUnitID: adUnitID,
                            rootViewController: nil,
                            adTypes: [.native],
                            options: nil)
        adLoader?.delegate = self
        adLoader?.load(request)
    }
    
    func refreshSamllAd() {
        didFailToLoadSmall = false
        samllNativeAd = nil

        let adUnitID = nativeId
        
        let request = Request()
        samllAdLoader = AdLoader(adUnitID: adUnitID,
                            rootViewController: nil,
                            adTypes: [.native],
                            options: nil)
        samllAdLoader?.delegate = self
        samllAdLoader?.load(request)
    }
}

// MARK: - Delegates
extension NativeAdViewModel: NativeAdLoaderDelegate, NativeAdDelegate {
    func adLoader(_ adLoader: AdLoader, didReceive nativeAd: NativeAd) {
        DispatchQueue.main.async {
            if adLoader == self.samllAdLoader {
                self.samllNativeAd = nativeAd
                self.didFailToLoadSmall = false
                nativeAd.delegate = self
                print("✅ Small Native ad loaded successfully.")
            } else {
                self.nativeAd = nativeAd
                self.didFailToLoad = false
                nativeAd.delegate = self
                print("✅ Native ad loaded successfully.")
            }
        }
    }

    func adLoader(_ adLoader: AdLoader, didFailToReceiveAdWithError error: Error) {
        DispatchQueue.main.async {
            
            if adLoader == self.samllAdLoader {
                self.didFailToLoadSmall = true
                print("❌ Small Native ad failed: \(error.localizedDescription)")
            } else {
                self.didFailToLoad = true
                print("❌ Native ad failed: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - NativeAdDelegate
    func nativeAdDidRecordClick(_ nativeAd: NativeAd) { print("🖱️ Click recorded") }
    func nativeAdDidRecordImpression(_ nativeAd: NativeAd) { print("👀 Impression recorded") }
    func nativeAdWillPresentScreen(_ nativeAd: NativeAd) { print("📱 Will present screen") }
    func nativeAdWillDismissScreen(_ nativeAd: NativeAd) { print("📴 Will dismiss screen") }
    func nativeAdDidDismissScreen(_ nativeAd: NativeAd) { print("✅ Screen dismissed") }
}


//class NativeAdViewModel: NSObject, ObservableObject, NativeAdLoaderDelegate {
//    @Published var nativeAd: NativeAd?
//    private var adLoader: AdLoader!
//    
//    func refreshAd() {
//        adLoader = AdLoader(
//            adUnitID: SessionManager.shared.getSplashData()?.nativeID ?? "",
//            rootViewController: nil,
//            adTypes: [.native], options: nil)
//        adLoader.delegate = self
//        adLoader.load(Request())
//    }
//    
//    func adLoader(_ adLoader: AdLoader, didReceive nativeAd: NativeAd) {
//        self.nativeAd = nativeAd
//        nativeAd.delegate = self
//    }
//    
//    func adLoader(_ adLoader: AdLoader, didFailToReceiveAdWithError error: Error) {
//        print("\(adLoader) failed with error: \(error.localizedDescription)")
//    }
//}
//
//extension NativeAdViewModel: NativeAdDelegate {
//  func nativeAdDidRecordClick(_ nativeAd: NativeAd) {
//    print("\(#function) called")
//  }
//
//  func nativeAdDidRecordImpression(_ nativeAd: NativeAd) {
//    print("\(#function) called")
//  }
//
//  func nativeAdWillPresentScreen(_ nativeAd: NativeAd) {
//    print("\(#function) called")
//  }
//
//  func nativeAdWillDismissScreen(_ nativeAd: NativeAd) {
//    print("\(#function) called")
//  }
//
//  func nativeAdDidDismissScreen(_ nativeAd: NativeAd) {
//    print("\(#function) called")
//  }
//}



