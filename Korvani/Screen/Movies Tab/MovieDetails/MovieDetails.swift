//
//  MovieDetails.swift
//  Korvani
//
//  Created by Kushang kaklotar on 16/07/26.
//

import SwiftUI
import Kingfisher

struct MovieDetails: View {
    @State var isShowMore = false
    @StateObject var viewModel = MovieDetailViewModel()
    
    var body: some View {
        ZStack {
            
            ScrollView(showsIndicators: false) {
                VStack {
                    
                    // Topbar
                    ZStack {
                        KFImage.url(URL(string: "https://upload.wikimedia.org/wikipedia/en/c/ce/Dhurandhar_poster.jpg"))
                            .resizable()
                            .scaledToFill()
                        
                        LinearGradient(colors: [.clear,.clear, .blackColour], startPoint: .top, endPoint: .bottom)
                        
                        VStack(alignment: .leading) {
                            Spacer()
                            
                            HStack {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("Movie")
                                        .padding(.vertical, 5)
                                        .padding(.horizontal, 12)
                                        .background(.whiteColour.opacity(0.4))
                                        .cornerRadius(10)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(.whiteColour.opacity(0.5), lineWidth: 1)
                                        )
                                    
                                    Text("123sfjha sadfklaslkdfj asl;kd jalsdkj ;alsdkjas;djk")
                                        .lineLimit(2)
                                        .font(.system(size: 22, weight: .semibold))
                                    
                                    HStack {
                                        Text("April 4,2025")
                                            .font(.system(size: 14, weight: .regular))
                                        
                                        HStack(spacing: 2) {
                                            Image("ic_star")
                                                .resizable()
                                                .frame(width: 14, height: 14)
                                            
                                            Text("4.2".prefix(3))
                                                .foregroundColor(.yellowColour)
                                                .font(.system(size: 14, weight: .regular))
                                        }
                                        .padding(2)
                                        .background(.blackColour.opacity(0.3))
                                        .cornerRadius(3)
                                    }
                                    
                                    Text("Sci-fi")
                                        .padding(.vertical, 6)
                                        .padding(.horizontal, 16)
                                        .background(.lightBlackColour.opacity(0.4))
                                        .cornerRadius(10)
                                }
                                
                                Spacer()
                            }
                        }
                        .padding(.horizontal)
                    }
                    .frame(width: screenWidth, height: screenHeight/2, alignment: .center)
                    .background(.whiteColour)
                    
                    
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Overview")
                                .font(.system(size: 18, weight: .medium))
                            Spacer()
                        }
                        
                        VStack(alignment: .leading, spacing: 0) {
                            Text("I'm working on building a calendar UI in SwiftUI using LazyVGrid. My intention is for the calendar to correctly display the dates of the month, adjusting for the position of the first day of the month (for example, if a month begins on a Wednesday, then the  should appear under the column)")
                                .foregroundColor(.grayColour)
                                .lineLimit(isShowMore ? nil : 3)
                                Button(isShowMore ? "Show less..." : "Show More...") {
                                    withAnimation {
                                        isShowMore.toggle()
                                    }
                                }
                        }
                    }
                    .padding(.top, 50)
                    .padding(.horizontal, 16)
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Movie info")
                                .font(.system(size: 18, weight: .medium))
                            Spacer()
                        }
                        
                        VStack {
                            VStack(spacing: 16) {
                                CelebrityDetails.PersonalInfo(name: "info.name", details: "info.language", isLast: false)
                                CelebrityDetails.PersonalInfo(name: "info.name", details: "info.language", isLast: true)
                            }
                            .padding(.vertical, 16)
                        }
                        .background(.lightBlackColour)
                        .cornerRadius(10)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 14)

                    MovieDetailsDesign.WatchItems(viewModel: viewModel)
                    
                    Spacer()
                }
            }
        }
        .defaultPage()
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    MovieDetails()
}

class MovieDetailsDesign {
    
    struct WatchItems: View {
        @State private var selectedTab: MediaTab = .topCast
        @StateObject var viewModel: MovieDetailViewModel
        
        enum MediaTab: String, CaseIterable {
            case topCast = "Top Cast"
            case coreCrew = "Core Crew"
        }
        
        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    ForEach(MediaTab.allCases, id: \.self) { tab in
                        CelebrityDetails.WatchInfo(itemName: tab.rawValue, isSelected: self.selectedTab == tab)
                            .onTapGesture {
                                if !viewModel.isLoading {
                                    withAnimation(.spring()) {
                                        self.selectedTab = tab
//                                        viewModel.showMovieSeries(media: self.selectedTab == .movies ? 0 : 1)
                                    }
                                }
                            }
                            .transition(.slide)
                    }
                    
                    Spacer()
                    
                    if viewModel.isLoading {
                        DefaultDesign.Loader()
                    } else {
                        Button {
                            print("View all")
                        } label: {
                            Text("View all")
                                .foregroundColor(.mediumOrangeColour)
                                .font(.system(size: 12,weight: .semibold))
                        }
                    }
                }
                
                Divider()
                    .background(.grayColour.opacity(0.3))
            }
            .padding(.horizontal, 16)
            .padding(.top, 14)
        }
    }
    
}
