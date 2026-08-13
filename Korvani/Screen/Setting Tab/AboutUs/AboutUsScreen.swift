//
//  AboutUsScreen.swift
//  Korvani
//
//  Created by Kushang kaklotar on 13/08/26.
//

import SwiftUI

struct AboutUsScreen: View {
    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    }
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            DefaultDesign.Header(name: "ABOUT_US", back: {
                self.dismiss()
            })
            .padding(.horizontal, 16)
            
            ScrollView(.vertical, showsIndicators: false){
                VStack(alignment: .leading, spacing: 10) {
                    HStack(alignment: .center) {
                        Image("App_icon")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 150)
                        
                        VStack(spacing: 12){
                            Text(appName)
                                .font(.system(size: 20))
                            
                            Text("Version - \(appVersion)")
                                .font(.system(size: 20))
                        }
                        .padding(30)
                    }
                    .padding(.leading, 30)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                VStack(alignment: .leading, spacing: 10) {
                    
                    Text("About This App:")
                        .font(.system(size: 20))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("This application is designed to help users discover and explore movies and TV shows by offering comprehensive information including cast and crew details, posters, ratings, trailers, and overviews. Its primary purpose is informational and for content discovery only.")
                        .font(.system(size: 16))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Rectangle()
                        .fill(Color.gray.opacity(0.4))
                        .frame(height: 1)
                        .padding(.vertical, 8)
                    
                    Text("📡  Data Source")
                        .font(.system(size: 20))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("This product utilizes the TMDb (The Movie Database) public API to provide accurate and up-to-date metadata.Please note that this app is not certified or endorsed by TMDb.")
                        .font(.system(size: 20))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Image("ic_imdb_thumb")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 150, height: 20)
                        .padding(.vertical, 12)
                    
                    Text("https://www.themoviedb.org")
                        .font(.system(size: 16))
                        .foregroundColor(.blue)
                        .onTapGesture {
                            UIApplication.shared.open(URL(string: "https://www.themoviedb.org")!)
                        }
                    
                    Text("All movie and TV show data, including images and descriptions, are used in accordance with TMDb’s usage guidelines.")
                        .font(.system(size: 16))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    
                    Text("For more information on TMDB terms and API usage:\n")
                        .font(.system(size: 16))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("https://www.themoviedb.org/documentation/api/terms-of-use")
                        .font(.system(size: 16))
                        .foregroundColor(.blue)
                        .onTapGesture {
                            UIApplication.shared.open(URL(string: "https://www.themoviedb.org/documentation/api/terms-of-use")!)
                        }
                    
                    Rectangle()
                        .fill(Color.gray.opacity(0.4))
                        .frame(height: 1)
                        .padding(.vertical, 8)
                    
                    Text("❗Disclaimer")
                        .font(.system(size: 20))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("- This app does not stream, host, or allow playback of full movies or TV shows.")
                        .font(.system(size: 16))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("- It is not affiliated with or sponsored by any studios, streaming platforms, or content distributors.")
                        .font(.system(size: 16))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("- All trademarks, logos, and intellectual property belong to their respective owners and are used for reference purposes only.")
                        .font(.system(size: 16))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                }
                .padding(12)
            }
        }
        .defaultPage()
    }
}

#Preview {
    AboutUsScreen()
}
