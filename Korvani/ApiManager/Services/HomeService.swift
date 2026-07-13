//
//  HomeService.swift
//  Movies Guide
//
//  Created by Kushang  on 19/12/25.
//

import Foundation
import Alamofire

class HomeServices{
    
    static let shared = { HomeServices() }()
    
    func topRatedAPI(parameters: [String: Any] = [:], success: @escaping (Int, MovieSearchResponse) -> (), failure: @escaping (String) -> ()) {
        APIManager.shared.requestAPIWithGetMethod(method: .get, urlString: topRatedMovieUrl, responseType: MovieSearchResponse.self) { statusCode, response in
            success(statusCode, response)
        } failure: { error in
            failure(error)
        }
    }
    
    func celecrityAPI(parameters: [String: Any] = [:],page: Int, success: @escaping (Int, CelebrityResponse) -> (), failure: @escaping (String) -> ()) {
        APIManager.shared.requestAPIWithGetMethod(method: .get, urlString: celebrityUrl+"\(page)", responseType: CelebrityResponse.self) { statusCode, response in
            success(statusCode, response)
        } failure: { error in
            failure(error)
        }
    }
}
