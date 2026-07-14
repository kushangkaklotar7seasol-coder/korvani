//
//  HomeViewModel.swift
//  Korvani
//
//  Created by Kushang kaklotar on 10/07/26.
//

import Foundation
internal import Combine
import Alamofire
import UIKit

class HomeViewModel : ObservableObject {
    @Published var selectedTab = 0
    @Published var topRatedMovie: [Movie] = []
    @Published var celebrity: CelebrityResponse?
    @Published var isLoading = false
    @Published var navigationItem = (celebrity: false, movieDetail: false, weather: false, unitConverter: false)
    @Published var celebritySelectedId: Int?
    @Published var todayWeather: ForecastItem?
    @Published var locationStaus: Int = 5 // 0=Allow, 1=Restricted, 2=Denied, 3=authorizedAlways, 4=Location Disable, 5=Loading
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleDataNotification(_:)), name: .didReceiveData, object: nil)
        
        self.topRatedMovieAPI()
    }
    
    func onApper(){
        locationManager.checkLocationAuthorization()
    }
    
    func openAppSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
        }
    }
    
    @objc func handleDataNotification(_ notification: Notification) {
        if let userInfo = notification.userInfo, let receivedText = userInfo["STATUS"] as? Int {
            self.locationStaus = receivedText
            
            if self.locationStaus == 0 {
                self.weatherAPI()
            }
        }
    }
    
    // MARK: - API Call's -
    func topRatedMovieAPI() {
        if Utility.isInternetAvailable() {
            isLoading = true
            HomeServices.shared.topRatedAPI { statusCode, response in
                self.isLoading = false
                self.topRatedMovie = response.results
                self.topRatedMovie.removeLast(self.topRatedMovie.count-5)
                self.celebrityAPI()
            } failure: { error in
                self.isLoading = false
                print(error)
            }
        } else {
            print("No internet connected")
        }
    }
    
    func celebrityAPI() {
        if Utility.isInternetAvailable() {
            isLoading = true
            HomeServices.shared.celecrityAPI(page: 1) { statusCode, response in
                self.isLoading = false
                self.celebrity = response
            } failure: { error in
                self.isLoading = false
                print(error)
            }
        } else {
            print("No internet connected")
        }
    }
    
    func weatherAPI() {
        if Utility.isInternetAvailable() {
            WeatherService.shared.weatherAPI { statusCode, response in
                self.locationStaus = 0
                self.todayWeather = response.list.first
            } failure: { error in
                print(error)
            }
        } else {
            print("No internet connected")
        }
    }
}
