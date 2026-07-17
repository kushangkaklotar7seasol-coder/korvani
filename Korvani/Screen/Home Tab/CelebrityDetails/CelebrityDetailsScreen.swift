//
//  CelebrityDetailsScreen.swift
//  Korvani
//
//  Created by Kushang kaklotar on 11/07/26.
//

import SwiftUI
import Kingfisher

struct CelebrityDetailsScreen: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: CelebrityDetailsViewModel
    @State var isShowMore = false
    @State private var isTruncated = false
    
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack() {
                    CelebrityDetails.ImageView(url: viewModel.celebrityDetail?.profilePath ?? "", name: viewModel.celebrityDetail?.name ?? "", profesion: viewModel.celebrityDetail?.knownForDepartment ?? "")
                        .padding(.top, 40)
                    
                    if viewModel.celebrityDetail?.biography != "" {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Biography")
                                    .font(.system(size: 18, weight: .medium))
                                Spacer()
                            }
                            
                            VStack(alignment: .leading, spacing: 0) {
                                Text(viewModel.celebrityDetail?.biography ?? "")
                                    .foregroundColor(.grayColour)
                                    .lineLimit(isShowMore ? nil : 3)
                                    Button(isShowMore ? "Show less..." : "Show More...") {
                                        withAnimation {
                                            isShowMore.toggle()
                                        }
                                    }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 29)
                    }
                    
                    if !viewModel.personalInformation.isEmpty {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Personal info")
                                    .font(.system(size: 18, weight: .medium))
                                Spacer()
                            }
                            
                            VStack {
                                VStack(spacing: 16) {
                                    ForEach(viewModel.personalInformation.indices, id: \.self) { information in
                                        let info = viewModel.personalInformation[information]
                                        CelebrityDetails.PersonalInfo(name: info.name, details: info.language, isLast: information+1 == viewModel.personalInformation.count)
                                    }
                                }
                                .padding(.vertical, 16)
                            }
                            .background(.lightBlackColour)
                            .cornerRadius(10)
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 14)
                    }
                    
                    
                    VStack {
                        CelebrityDetails.WatchItems(viewModel: viewModel)
                        
                        if !viewModel.movies.isEmpty {
                            ScrollView(.horizontal, showsIndicators: false) {
                                
                                HStack {
                                    ForEach(viewModel.movies.indices, id: \.self) { item in
                                        MovieDetail.card(movies: viewModel.movies[item], numbersOfCard: 3)
                                    }
                                }
                                .padding(.horizontal, 16)
                            }
                        } else {
                            Text("No Media Found")
                                .font(.system(size: 22, weight: .bold))
                                .padding()
                        }
                    }
                    
                    Spacer()
                }
            }
            
            VStack {
                HStack {
                    Button {
                        self.dismiss()
                    } label: {
                        Image("ic_back")
                            .resizable()
                            .frame(width: 40, height: 40, alignment: .center)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
             
                Spacer()
            }
        }
        .defaultPage()
    }
    
    private func checkTruncation(fullHeight: CGFloat) {
        let lineHeight = UIFont.systemFont(ofSize: 12).lineHeight // match your font
        let threeLineHeight = lineHeight * 3
        isTruncated = fullHeight > threeLineHeight
    }
}

#Preview {
    CelebrityDetailsScreen(viewModel: CelebrityDetailsViewModel())
}
class CelebrityDetails {
    struct ImageView: View {
        var url: String
        var name: String
        var profesion: String
        
        var body: some View {
            ZStack {
                KFImage.url(URL(string: imageUrl+self.url))
                    .resizable()
                    .scaledToFill()
                
                LinearGradient(colors: [.clear, .blackColour], startPoint: .top,endPoint: .bottom)
                
                VStack {
                    Spacer()
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text(name)
                                .font(.system(size: 24, weight: .semibold))
                                .lineLimit(1)
                            
                            if profesion != "" {
                                Text(profesion)
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundColor(.grayColour)
                                    .lineLimit(1)
                                    .multilineTextAlignment(.leading)
                            }
                        }
                        .padding(16)
                        
                        Spacer()
                    }
                }
                .frame(width: screenWidth-32, height: screenWidth-32, alignment: .center)
            }
            .frame(width: screenWidth-32, height: screenWidth-32, alignment: .center)
            .cornerRadius(16)
            .padding(.top, 24)

        }
    }
    
    struct PersonalInfo: View {
        var name: String
        var details: String
        var isLast: Bool = false
        
        var body: some View {
            VStack(spacing: 0) {
                
                HStack {
                    Circle()
                        .foregroundColor(.orangeColour)
                        .frame(width: 6, height: 6, alignment: .center)
                    
                    Text(name)
                        .foregroundColor(.grayColour)
                    
                    Spacer()
                    
                    Text(details)
                        .foregroundColor(.whiteColour)
                        .lineLimit(1)
                }
                .font(.system(size: 14))
                
                if !isLast {
                    HStack {
                        ZStack { }
                            .frame(width: 2, height: 20)
                            .background(.borderColour)
                            .padding(.leading, 1.5)
                        
                        ZStack { }
                            .frame(maxWidth: .infinity)
                            .frame(height: 1)
                            .background(.borderColour)
                            .padding(.leading, 1.5)
                            .padding(.top, 6)
                        
                        Spacer()
                    }
                }
            }
            .padding(.horizontal, 16)

        }
    }
    
    struct WatchInfo: View {
        var itemName: String
        var isSelected: Bool
        
        var body: some View {
                VStack(spacing: 4) {
                    Text(itemName)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(self.isSelected ? .whiteColour : .grayColour)
                    
                    ZStack {
                        Text("\(itemName)  ")
                            .foregroundColor(.clear)
                    }
                    .frame(height: 2)
                    .background(self.isSelected ? .whiteColour : .clear)
                    .clipShape(
                        .rect(
                            topLeadingRadius: 20,
                            bottomLeadingRadius: 0,
                            bottomTrailingRadius: 0,
                            topTrailingRadius: 20
                        )
                    )
                }
        }
    }
    
    struct WatchItems: View {
        @State private var selectedTab: MediaTab = .movies
        @StateObject var viewModel: CelebrityDetailsViewModel
        
        enum MediaTab: String, CaseIterable {
            case movies = "Movies"
            case tvShows = "TV Shows"
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
                                        viewModel.showMovieSeries(media: self.selectedTab == .movies ? 0 : 1)
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

class MovieDetail {
    
    struct card: View {
        var movies: MediaItem
        var numbersOfCard = 2
        var isShowLike = true
        var onLike: ((Bool) -> Void)?
        
        @State var isLiked: Bool = false
        
        var cardWidth: CGFloat {
            switch numbersOfCard {
            case 2:
                return (screenWidth-47) / 2
            case 3:
                return (screenWidth-28) / 3
            default:
                return screenWidth-32
            }
        }
        
        var cardHeight: CGFloat {
            return cardWidth*1.25
        }
        
        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                
                ZStack {
                    KFImage.url(URL(string: imageUrl+(movies.posterPath ?? "")))
                        .placeholder { progress in
                            Image("img_nomovie")
                                .resizable()
                                .scaledToFill()
                        }
                        .resizable()
                        .scaledToFill()
                        .frame(width: cardWidth, height: cardHeight)
                        .clipped()
                    
                    VStack {
                        HStack {
                            Spacer()
                            
                            if isShowLike {
                                Button {
                                    if self.isLiked {
                                        database.removeMovie(id: movies.id)
                                    } else {
                                        database.addMovie(movies)
                                    }
                                    
                                    self.isLiked.toggle()
                                    onLike?(self.isLiked)
                                } label: {
                                    Image(self.isLiked ? "ic_like" : "ic_unlike")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                }
                            }
                        }
                        .padding(6)
                        
                        Spacer()
                        
                        HStack {
                            HStack(spacing: 2) {
                                Image("ic_star")
                                    .resizable()
                                    .frame(width: 10, height: 10)
                                
                                Text("\(movies.voteAverage/2)".prefix(3))
                                    .foregroundColor(.yellowColour)
                                    .font(.system(size: 10,weight: .semibold))
                            }
                            .padding(2)
                            .background(.blackColour.opacity(0.3))
                            .cornerRadius(3)
                            
                            Spacer()
                        }
                        .padding(6)
                    }
                }
                .frame(width: cardWidth, height: cardHeight, alignment: .center)
                .background(.grayColour)
                .cornerRadius(12)
                
                Text((movies.title ?? movies.name) ?? "")
                    .foregroundColor(.whiteColour)
                    .padding(.top, 8)
                    .lineLimit(1)
                
                if let releaseDate = (movies.releaseDate ?? movies.firstAirDate) {
                    HStack(spacing: 3) {
                        
                        Text(releaseDate/*.prefix(4)*/)
                        
//                        Circle()
//                            .frame(width: 4, height: 4, alignment: .center)
                        
                        //Text("\(movies.genreIds.first ?? 0)")
                    }
                    .padding(.top, 3)
                    .foregroundColor(.grayColour)
                }
            }
            .font(.system(size: 12, weight: .medium))
            .frame(width: cardWidth)
            .onAppear() {
                self.isLiked = database.isMovieLiked(id: movies.id)
            }
        }
    }
    
    
    struct MediaBunchView: View {
        var item: MediaBunch
        var onViewAll: (() -> ())?
        var onMovie: ((MediaItem) -> ())?
        
        var body: some View {
            VStack(spacing: 10) {
                HStack {
                    Text(item.name)
                        .font(.system(size: 18, weight: .semibold))
                    
                    Spacer()
                    
                    Button {
                        self.onViewAll?()
                    } label: {
                        Text("View all")
                            .foregroundColor(.mediumOrangeColour)
                            .font(.system(size: 12,weight: .semibold))
                    }
                }
                .padding(.horizontal, 16)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(item.media.results, id: \.id) { movie in
                            card(movies: movie, numbersOfCard: 3)
                                .onTapGesture {
                                    self.onMovie?(movie)
                                }
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
        }
    }
}
