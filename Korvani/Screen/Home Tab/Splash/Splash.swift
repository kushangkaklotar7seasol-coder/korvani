//
//  Splash.swift
//  Korvani
//
//  Created by Kushang kaklotar on 09/07/26.
//

import SwiftUI
import AWSCore

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
        .frame(minWidth: screenWidth, minHeight: screenHeight)
        .background(.blackColour)
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
            self.webservice_getJSON_api()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.requestTrackingPermission() {
                    viewModel.navigationManager()
                }
            }
        }
    }
    
    func requestTrackingPermission(completion: @escaping () -> Void) {
        
        let credentials = AWSStaticCredentialsProvider(accessKey: ACCESS, secretKey: SECRET)
        let configuration = AWSServiceConfiguration(region: AWSRegionType.EUWest1, credentialsProvider: credentials)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        AdsManager.shared.requestForConsentForm { _ in
            DispatchQueue.main.async {
                completion()
            }
        }
    }

//    func generalInfoAPI(){
//        if Utility.isInternetAvailable() {
//            HomeServices.shared.generalInfoAPI { statusCode, response in
//                print(response)
//            } failure: { error in
//                print(error)
//            }
//        } else {
//            print("No internet connected")
//        }
//    }
    
    
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
//        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData

        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        configuration.urlCache = nil

        let session = URLSession(configuration: configuration)

        let task = session.dataTask(with: request) { data, response, error in

            defer {
                DispatchQueue.main.async {
                    completion?()
                }
            }

            if let error = error {
                print("Error:- \(error.localizedDescription)")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Invalid Response")
                return
            }

            guard let data = data else {
                print("No Data Found")
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    print(json)
                    
                    if let result = json["extraFields"] as? [String: Any] {
                        print(result)
                    }
                }
                DispatchQueue.main.async { completion?() }
                
            } catch {
                print("❌ JSON Parse Error:", error.localizedDescription)
                DispatchQueue.main.async { completion?() }
            }
        }

        task.resume()
    }
    
}

#Preview {
    Splash()
}
