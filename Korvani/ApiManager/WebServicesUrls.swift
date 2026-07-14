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

// MARK: - Translate -
let translateAPI = "https://translate.googleapis.com/translate_a/single?"
