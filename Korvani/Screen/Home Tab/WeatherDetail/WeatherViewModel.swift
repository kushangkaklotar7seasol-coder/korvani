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
    @Published var weeklyForecast: [ForecastItem] = []
    
    init() {
        self.weatherAPI()
    }
    
    func weatherAPI() {
        if Utility.isInternetAvailable() {
            WeatherService.shared.weatherAPI { statusCode, response in
                self.weathers = response
                self.selectedDay = response.list.first
                
                var dailyDict: [String: ForecastItem] = [:]
                
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                for forecast in response.list {
                    
                    if let date = formatter.date(from: forecast.dtTxt) {
                        
                        let dayFormatter = DateFormatter()
                        dayFormatter.dateFormat = "EEEE"
                        
                        let dayName =
                        dayFormatter.string(from: date)
                        
                        if dailyDict[dayName] == nil {
                            dailyDict[dayName] = forecast
                        }
                    }
                }
                
                self.weeklyForecast =
                Array(dailyDict.values)
                    .sorted { $0.dt < $1.dt }
                
            } failure: { error in
                print(error)
            }
        } else {
            print("No internet connected")
        }
    }
}
