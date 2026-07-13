//
//  WeatherService.swift
//  Korvani
//
//  Created by Kushang kaklotar on 13/07/26.
//

import Foundation
import Alamofire

class WeatherService {
    
    static let shared = { WeatherService() }()
    
    func weatherAPI(parameters: [String: Any] = [:], success: @escaping (Int, WeatherForecastResponse) -> (), failure: @escaping (String) -> ()) {
        APIManager.shared.weatherGetAPI(method: .get, urlString: weatherUrl, responseType: WeatherForecastResponse.self) { statusCode, response in
            success(statusCode, response)
        } failure: { error in
            failure(error)
        }
    }
}
