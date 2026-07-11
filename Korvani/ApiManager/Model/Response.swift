//
//  Response.swift
//  Mems
//
//  Created by iMac on 03/07/24.
//

import Foundation

class Response: Codable {
    var page: Int?
    var totalPages: Int?
    var totalResults: Int?
    var message: String?
    
    var movieResponse: MovieSearchResponse?
    
//    required init?(map: ObjectMapper.Map) { }
    
//    func mapping(map: ObjectMapper.Map) {
//        page          <- map["page"]
//        totalPages    <- map["total_pages"]
//        totalResults  <- map["total_results"]
//        message <- map["message"]
//        
//        datesResponse <- map["dates"]
//    }
}

enum APIResponse: Codable {
    case MovieSearchResponse
}
