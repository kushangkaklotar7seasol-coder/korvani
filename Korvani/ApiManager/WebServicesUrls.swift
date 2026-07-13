//
//  WebServicesUrls.swift
//  Mems
//
//  Created by iMac on 03/07/24.
//

import Foundation

let proxiUrl = "https://api-livevideocall.7seasol.in/proxy?url="
let serverUrl = proxiUrl + "https://api.themoviedb.org/3/"

//  MARK: - Home -
let topRatedMovieUrl = serverUrl + "movie/top_rated"
let celebrityUrl = serverUrl + "person/popular&page="
let celebeityDetailUrl = serverUrl + "person/"
let celebrityMovieUrl = "movie_credits"
let celebritySeriesUrl = "tv_credits"

// MARK: - Weather -
let weatherUrl = "https://api.openweathermap.org/data/2.5/forecast?lat=21.170240&lon=72.831062&appid=d74cbcfbbb9780cf5004245bc4311617&units=metric"
