//
//  MovieDetailService.swift
//  Korvani
//
//  Created by Kushang kaklotar on 17/07/26.
//

import Foundation
import Alamofire

class MovieDetailService {
    static let shared = { MovieDetailService() }()
    
    func movieDetail(parameters: [String: Any] = [:],id: Int, success: @escaping (Int, MovieDetailModel) -> (), failure: @escaping (String) -> ()) {
        APIManager.shared.requestAPIWithGetMethod(method: .get, urlString: movieDetailUrl+"\(id)", responseType: MovieDetailModel.self) { statusCode, response in
            success(statusCode, response)
        } failure: { error in
            failure(error)
        }
    }
    
    func castAndCrew(parameters: [String: Any] = [:],id: Int, success: @escaping (Int, MovieCredits) -> (), failure: @escaping (String) -> ()) {
        APIManager.shared.requestAPIWithGetMethod(method: .get, urlString: movieDetailUrl+"\(id)/credits", responseType: MovieCredits.self) { statusCode, response in
            success(statusCode, response)
        } failure: { error in
            failure(error)
        }
    }
    
    func movieImage(parameters: [String: Any] = [:],id: Int, success: @escaping (Int, MovieImages) -> (), failure: @escaping (String) -> ()) {
        APIManager.shared.requestAPIWithGetMethod(method: .get, urlString: movieDetailUrl+"\(id)/images", responseType: MovieImages.self) { statusCode, response in
            success(statusCode, response)
        } failure: { error in
            failure(error)
        }
    }
    
    func movieVideo(parameters: [String: Any] = [:],id: Int, success: @escaping (Int, MovieVideos) -> (), failure: @escaping (String) -> ()) {
        APIManager.shared.requestAPIWithGetMethod(method: .get, urlString: movieDetailUrl+"\(id)/videos", responseType: MovieVideos.self) { statusCode, response in
            success(statusCode, response)
        } failure: { error in
            failure(error)
        }
    }
}
