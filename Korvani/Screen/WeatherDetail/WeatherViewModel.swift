//
//  WeatherViewModel.swift
//  Korvani
//
//  Created by Kushang kaklotar on 13/07/26.
//

import Foundation
internal import Combine

class WeatherViewModel: ObservableObject {
    @Published var selectedDay: ForecastItem?
    @Published var weathers: WeatherForecastResponse?
    
    init() {
        self.weatherAPI()
    }
    
    func weatherAPI() {
        if Utility.isInternetAvailable() {
            WeatherService.shared.weatherAPI { statusCode, response in
                self.weathers = response
                self.selectedDay = response.list.first
            } failure: { error in
                print(error)
            }
        } else {
            print("No internet connected")
        }
    }
}
