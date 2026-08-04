//
//  Splash.swift
//  Korvani
//
//  Created by Kushang kaklotar on 09/07/26.
//

import SwiftUI
import AWSCore
//import AWSCore

struct Splash: View {
    @StateObject var viewModel = SplashViewModel()
    
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
        .onAppear {
            SwipeBackManager.shared.isEnabled = false
            self.webservice_getJSON_api(completion: {
                Task {
                    await handleFlow()
                }
            })
        }
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
