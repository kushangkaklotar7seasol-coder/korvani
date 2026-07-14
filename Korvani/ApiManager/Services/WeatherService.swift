//
//  WeatherService.swift
//  Korvani
//
//  Created by Kushang kaklotar on 13/07/26.
//

import Foundation
import Alamofire
internal import CoreLocation

class WeatherService {
    
    static let shared = { WeatherService() }()
    
    func weatherAPI(parameters: [String: Any] = [:], success: @escaping (Int, WeatherForecastResponse) -> (), failure: @escaping (String) -> ()) {
        
        let latitude = locationManager.manager.location?.coordinate.latitude ?? 0.0
        let long = locationManager.manager.location?.coordinate.longitude ?? 0.0
        
        let weatherUrl = "https://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(long)&appid=d74cbcfbbb9780cf5004245bc4311617&units=metric"
        
        APIManager.shared.weatherGetAPI(method: .get, urlString: weatherUrl, responseType: WeatherForecastResponse.self) { statusCode, response in
            success(statusCode, response)
        } failure: { error in
            failure(error)
        }
    }
}
