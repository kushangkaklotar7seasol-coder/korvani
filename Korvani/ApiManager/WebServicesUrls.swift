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
let searchUrl = serverUrl + "search/movie?query="
let searchSeriesUrl = serverUrl + "search/tv?query="

// MARK: - Translate -
let translateAPI = "https://translate.googleapis.com/translate_a/single?"

// MARK: - Wallpaper -
let wallpapaerUrl = "https://api-pexels.7seasol.in/api/images/by-category?category=trending&page="
