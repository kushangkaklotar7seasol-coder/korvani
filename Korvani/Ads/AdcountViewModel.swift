////
////  AdcountViewModel.swift
////  MovieBox
////
////  Created by Parthiv Akbari on 19/03/26.
////
//
//import Foundation
//import SwiftUI
//import Combine
//import GoogleMobileAds
//
//final class AdCountViewModel: BaseViewModel {
////    @AppStorage(SessionKeys.isPro) var isPro = false
//    @Published var tapCount: Int = 0
//    @Published var isAdJustShown: Bool = false
//    
//    let interstitialManager = InterstitialAdManager()
//    var cancellables = Set<AnyCancellable>()
//    static let sharedd = AdCountViewModel()
//
//    // MARK: - Init
//    override init() {
//        super.init()
//        print("🚀 AdCountViewModel initialized — preloading interstitial ad...")
//        reloadAd()
//        observeAfterClickChange()
//    }
//
//    // MARK: - Observe afterClick changes dynamically
//    private func observeAfterClickChange() {
//        NotificationCenter.default.publisher(for: NSNotification.afterClickUpdated)
//            .sink { [weak self] _ in
//                guard let self else { return }
//                print("⚙️ Updated afterClick threshold to: \(adsCount)")
//            }
//            .store(in: &cancellables)
//    }
//
//    // MARK: - Tap Logic
//    func registerTap() {
//        guard !isPro else { return }
//        
//        // 🚫 Prevent immediate re-trigger after ad
//        if isAdJustShown {
//            print("⏸ Skipping tap - ad just shown")
//            isAdJustShown = false
//            return
//        }
//        
//        tapCount += 1
//        print("🔹 Total Tap Count: \(tapCount)")
//
//        if tapCount >= adsCount {
//            print("🟢 Tap count reached threshold (\(adsCount)) — showing ad.")
//            showInterstitial()
//            tapCount = 0
//            isAdJustShown = true
//        }
//    }
//
//    // MARK: - Show & Reload Ads
//    private func showInterstitial() {
//        interstitialManager.present()
//        reloadAd()
//    }
//
//    func reloadAd() {
//        print("🔄 Reloading interstitial ad...")
//        interstitialManager.load()
//    }
//}

import Foundation
import SwiftUI
import Combine
import GoogleMobileAds

final class AdCountViewModel: BaseViewModel {
    @Published var tapCount: Int = 0
    @Published var isAdJustShown: Bool = false

    let interstitialManager = InterstitialAdManager()
    var cancellables = Set<AnyCancellable>()
    static let sharedd = AdCountViewModel()

    // MARK: - Init
    override init() {
        super.init()
        print("🚀 AdCountViewModel initialized — preloading interstitial ad...")
        reloadAd()
        observeAfterClickChange()
    }

    // MARK: - Observe afterClick changes dynamically
    private func observeAfterClickChange() {
        NotificationCenter.default.publisher(for: NSNotification.afterClickUpdated)
            .sink { [weak self] _ in
                guard let self else { return }
                print("⚙️ Updated afterClick threshold to: \(adsCount)")
            }
            .store(in: &cancellables)
    }

    // MARK: - Tap Logic
    func registerTap() {
        guard !isPro else { return }



        tapCount += 1
        
                if isAdJustShown {
                    print("⏸ Skipping tap - ad just shown")
                    isAdJustShown = false
                    return
                }
        
        print("TAP COUNT = \(tapCount)")
        
        if tapCount >= adsCount {
            print("ADD LOAD")
            showInterstitial()
            tapCount = 0
            isAdJustShown = true
        }
    }

    func registerTap(completion: @escaping () -> Void) {
            tapCount += 1

            guard !isPro else {
                completion()
                return
            }

            if tapCount >= adsCount {
                tapCount = 0

                interstitialManager.present {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        completion()
                    }
                }
            } else {
                completion()
            }
        }

    // MARK: - Show & Reload Ads
    private func showInterstitial() {
        interstitialManager.present()
        reloadAd()
    }

    func reloadAd() {
        print("🔄 Reloading interstitial ad...")
        interstitialManager.load()
    }
}

//import Foundation
//import SwiftUI
//import Combine
//import GoogleMobileAds
// 
//final class AdCountViewModel: BaseViewModel {
//    @Published var tapCount: Int = 0
//    @Published var isAdJustShown: Bool = false
//    
//    let interstitialManager = InterstitialAdManager()
//    var cancellables = Set<AnyCancellable>()
//    static let sharedd = AdCountViewModel()
//    
//    // MARK: - Init
//    override init() {
//        super.init()
//        print("🚀 AdCountViewModel initialized — preloading interstitial ad...")
//        reloadAd()
//        observeAfterClickChange()
//    }
//    
//    // MARK: - Observe afterClick changes dynamically
//    private func observeAfterClickChange() {
//        NotificationCenter.default.publisher(for: NSNotification.afterClickUpdated)
//            .sink { [weak self] _ in
//                guard let self else { return }
//                print("⚙️ Updated afterClick threshold to: \(adsCount)")
//            }
//            .store(in: &cancellables)
//    }
//    
//    // MARK: - Tap Logic
//    func registerTap() {
//        guard !isPro else { return }
//        
//        if isAdJustShown {
//            print("⏸ Skipping tap - ad just shown")
//            isAdJustShown = false
//            return
//        }
//        
//        tapCount += 1
//        
//        if tapCount >= adsCount {
//            showInterstitial()
//            tapCount = 0
//            isAdJustShown = true
//        }
//    }
//    
//    func registerTap(completion: @escaping () -> Void) {
//        tapCount += 1
//        
//        guard !isPro else {
//            completion()
//            return
//        }
//        
//        if tapCount >= adsCount {
//            tapCount = 0
//            
//            interstitialManager.present {
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//                    completion()
//                }
//            }
//        } else {
//            completion()
//        }
//    }
//    
//    // MARK: - Show & Reload Ads
//    private func showInterstitial() {
//        interstitialManager.present()
//        reloadAd()
//    }
//    
//    func reloadAd() {
//        print("🔄 Reloading interstitial ad...")
//        interstitialManager.load()
//    }
//}
//
