//
//  Splash.swift
//  Korvani
//
//  Created by Kushang kaklotar on 09/07/26.
//

import SwiftUI
import AWSCore
//import AWSCore
import StoreKit

struct Splash: View {
    @StateObject var viewModel = SplashViewModel()
    let subscriptionManager = SubscriptionManager.shared
    
    var body: some View {
        ZStack {
            VStack {
                Image("ic_app_name")
                    .frame(width: 196)
                
                Text(Strings.splashSubtitle)
                    .foregroundColor(.grayColour)
            }
        }
        .navigationDestination(isPresented: $viewModel.navigation.OnBoding) {
            OnBoding()
        }
        .navigationDestination(isPresented: $viewModel.navigation.language) {
            LanguageScreen()
        }
        .navigationDestination(isPresented: $viewModel.navigation.home) {
            TabBarScreen()
        }
        .task {
            isPro = UserdefaultManager.shared.getPro() ?? true
            await subscriptionManager.checkSubscriptionAtLaunch()
        }
        .onAppear {
            // SwipeBackManager.shared.isEnabled = false
            self.webservice_getJSON_api(completion: {
                Task {
                    await handleFlow()
                }
            })
        }
    }
    
    func isPremiumActive(resule: @escaping (Bool) -> ()) async {
            for await result in Transaction.currentEntitlements {
                guard case .verified(let transaction) = result else {
                    continue // Skip unverified/invalid receipts
                }
                
                // Check for Auto-Renewable Subscriptions or Non-Consumable Lifetime Purchases
                if transaction.productType == .autoRenewable || transaction.productType == .nonConsumable {
                    
                    // 1. Ensure it hasn't been refunded or revoked by Apple
                    if transaction.revocationDate != nil {
                        continue
                    }
                    
                    // 2. Ensure the subscription hasn't expired
                    if let expirationDate = transaction.expirationDate, expirationDate < Date() {
                        continue
                    }
                    
                    // If we reached here, the user has an ACTIVE Premium status!
                    resule(true)
                }
            }
            
        resule(false) // No active premium entitlement found
        }
    
    func handleFlow() async {
        print("🔥 AppOpen ID:", appopenId)
        
        Task {
            print("✅ isPro after check:", isPro)
            
            if !isPro {
                BannerAdManager.shared.loadBanner()
            }
            
            // 🔥 STEP 2: PRO USER → DIRECT NAVIGATION
            if isPro {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    viewModel.navigationManager()
                }
                return
            }
            
            // 🔥 STEP 3: NON-PRO → SHOW AD
            AdCountViewModel.sharedd.reloadAd()
            
            await AppOpenAdManager.shared.loadAd()
            
            AppOpenAdManager.shared.showAdIfAvailable {
                DispatchQueue.main.async {
                    viewModel.navigationManager()
                }
            }
        }
      }
    

    func webservice_getJSON_api(completion: (() -> Void)? = nil) {

        guard let url = URL(string: generalInfoUrl) else {
            print("invalid url")
            DispatchQueue.main.async {
                completion?()
            }
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        configuration.urlCache = nil

        let session = URLSession(configuration: configuration)

        let task = session.dataTask(with: request) { data, response, error in

            if let error = error {
                print("Error:- \(error.localizedDescription)")
                DispatchQueue.main.async { completion?() }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Invalid Response")
                DispatchQueue.main.async { completion?() }
                return
            }

            guard let data = data else {
                Toast.shared.show(message: "No Data Found", type: .error)
                DispatchQueue.main.async { completion?() }
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    print(json)
                    
                    bannerId = json["bannerId"] as? String ?? ""
                    nativeId = json["nativeId"] as? String ?? ""
                    interstialId = json["interstialId"] as? String ?? ""
                    appopenId = json["appopenId"] as? String ?? ""
                    rewardId = json["rewardId"] as? String ?? ""
                    
                    addButtonColor = json["addButtonColor"] as? String ?? "#FA5026"
                    
                    adsPlus = 0
                    adsCount = Int(json["afterClick"] as? String ?? "2") ?? 2
                    
                    if let result = json["extraFields"] as? [String: Any] {
                        let result  = result
                        
                        proxiUrl = result["appjson"] as? String ?? ""
                        isYoutubeEnabled = result["isYoutubeEnabled"] as? String == "false" ? false : true
                        weatherAPIKey = result["weatherAPIKey"] as? String ?? "d74cbcfbbb9780cf5004245bc4311617"
                        
                        isShowLifetime = result["iapLifetime"] as? String == "true" ? true : false
                        isShowYearlyPlan = result["iapYearlyPlan"] as? String == "true" ? true : false
                        isShowWeeklyPlan = result["iapWeeklyPlan"] as? String == "true" ? true : false
                        isShowMonthlyPlan = result["iapMonthlyPlan"] as? String == "true" ? true : false
                        isPremiumRequiredForYT = result["isPremiumRequiredForYT"] as? String == "true" ? true : false
                    }
                }
                DispatchQueue.main.async { completion?() }
                
            } catch {
                print("❌ JSON Parse Error:", error.localizedDescription)
                Toast.shared.show(message: "Json passing error", type: .error)
                DispatchQueue.main.async { completion?() }
            }
        }

        task.resume()
    }
    
}

struct SplashConetentView: View {
    
    var body: some View {
        ZStack {
            VStack {
                Image("ic_app_name")
                    .frame(width: 196)
                
                Text(Strings.splashSubtitle)
                    .foregroundColor(.grayColour)
            }
        }
    }
}
