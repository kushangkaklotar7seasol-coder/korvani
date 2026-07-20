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
    @StateObject var viewModel: MovieDetailViewModel
    @Environment(\.dismiss) private var dismiss
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    // Topbar
                    ZStack {
                        KFImage.url(URL(string: imageUrl+"\(viewModel.movieDetail?.posterPath ?? "")"))
                            .resizable()
                            .scaledToFill()
                        
                        LinearGradient(colors: [.clear,.clear, .blackColour], startPoint: .top, endPoint: .bottom)
                        
                        VStack(alignment: .leading) {
                            Spacer()
                            
                            HStack {
                                VStack(alignment: .leading, spacing: 10) {
                                    HStack {
                                        Text(viewModel.isMovie ?? true ? "Movie" : "Series")
                                            .padding(.vertical, 5)
                                            .padding(.horizontal, 12)
                                            .background(.whiteColour.opacity(0.4))
                                            .cornerRadius(10)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(.whiteColour.opacity(0.5), lineWidth: 1)
                                            )
                                            .padding(.horizontal)
                                        
                                        Spacer()
                                        
                                        if !(viewModel.movieVideo?.results.isEmpty ?? true) {
                                            Button {
                                                viewModel.openInYouTubeApp(videoID: viewModel.movieVideo?.results.first?.key ?? "")
                                            } label: {
                                                Image("ic_play")
                                                    .resizable()
                                                    .frame(width: 44, height: 44, alignment: .center)
                                            }
                                            .padding(.trailing, 16)
                                        }
                                    }
                                    .frame(height: 44)
                                    
                                    Text("\(viewModel.movieDetail?.title ?? viewModel.movieDetail?.name ?? "")")
                                        .lineLimit(2)
                                        .font(.system(size: 22, weight: .semibold))
                                        .padding(.horizontal)
                                    
                                    HStack {
                                        Text(viewModel.movieDetail?.releaseDate ?? viewModel.movieDetail?.firstAirDate ?? "")
                                            .font(.system(size: 14, weight: .regular))
                                        
                                        HStack(spacing: 2) {
                                            Image("ic_star")
                                                .resizable()
                                                .frame(width: 14, height: 14)
                                            
                                            let star = (viewModel.movieDetail?.voteAverage ?? 0.0)/2
                                            Text("\(star)".prefix(3))
                                                .foregroundColor(.yellowColour)
                                                .font(.system(size: 14, weight: .regular))
                                        }
                                        .padding(2)
                                        .background(.blackColour.opacity(0.3))
                                        .cornerRadius(3)
                                    }
                                    .padding(.horizontal)
                                    
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack {
                                            ForEach(viewModel.movieDetail?.genres ?? []) { gener in
                                                Text(gener.name)
                                                    .padding(.vertical, 6)
                                                    .padding(.horizontal, 16)
                                                    .background(.lightBlackColour.opacity(0.4))
                                                    .cornerRadius(10)
                                            }
                                        }
                                        .padding(.horizontal)
                                    }
                                }
                                
                                Spacer()
                            }
                        }
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
                            Text(viewModel.movieDetail?.overview ?? "")
                                .foregroundColor(.grayColour)
                                .lineLimit(isShowMore ? nil : 3)
                                Button(isShowMore ? "Show less..." : "Show More...") {
                                    withAnimation {
                                        isShowMore.toggle()
                                    }
                                }
                        }
                    }
                    .padding(.top, 80)
                    .padding(.horizontal, 16)
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Movie info")
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
                    
                    MovieDetailsDesign.WatchItems(mediaTab: ["Top Cast", "Core Crew"], onSelect: { index in
                        self.viewModel.selectedCastOption = index
                    }, onViewAll: {
                        self.viewModel.isShowAllCast = true
                    })
                    
                    if viewModel.selectedCastOption == 0 {
                        
                        if let cast = viewModel.movieCredits?.cast, !cast.isEmpty {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(cast, id: \.id) { cast in
                                        MovieDetailsDesign.CastDetail(image: cast.profilePath ?? "", firstName: cast.name, lastName: cast.character)
                                            .onTapGesture {
                                                viewModel.selectedCelebrityId = cast.id
                                                viewModel.isShowCastDetails = true
                                            }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        } else {
                            Text("No Cast Found")
                                .font(.system(size: 21, weight: .bold))
                                .foregroundColor(.whiteColour)
                        }
                    } else {
                        if let crew = viewModel.movieCredits?.crew, !crew.isEmpty{
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(crew, id: \.id) { crew in
                                        MovieDetailsDesign.CastDetail(image: crew.profilePath ?? "", firstName: crew.name, lastName: crew.department)
                                            .onTapGesture {
                                                viewModel.selectedCelebrityId = crew.id
                                                viewModel.isShowCastDetails = true
                                            }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        } else {
                            Text("No Crew Found")
                                .font(.system(size: 21, weight: .bold))
                                .foregroundColor(.whiteColour)
                        }
                    }
                    
                    MovieDetailsDesign.WatchItems(mediaTab: ["Poster", "Videos"], onSelect: { index in
                        viewModel.selectedMediaOption = index
                    }, onViewAll: {
                        if viewModel.selectedMediaOption == 0 {
                            viewModel.isShowPoster = true
                        } else {
                            viewModel.isShowVideo = true
                        }
                    })
                    
                    if viewModel.selectedMediaOption == 0 {
                        if let array = viewModel.movieImage?.posters, !array.isEmpty {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(array.indices, id: \.self) { index in
                                        MovieDetailsDesign.PosterMedia(isImage: true, image: array[index].filePath)
                                            .onTapGesture {
                                                viewModel.posterIndex = index
                                                viewModel.isShowPosterDetail = true
                                            }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        } else {
                            Text("No Photos Found")
                                .font(.system(size: 21, weight: .bold))
                                .foregroundColor(.whiteColour)
                        }
                    } else {
                        if let video = viewModel.movieVideo?.results, !video.isEmpty {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(video, id: \.key) { video in
                                        MovieDetailsDesign.PosterMedia(isImage: false, image: video.key)
                                            .onTapGesture {
                                                viewModel.openInYouTubeApp(videoID: video.key)
                                            }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        } else {
                            Text("No Video Found")
                                .font(.system(size: 21, weight: .bold))
                                .foregroundColor(.whiteColour)
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
                        Image("ic_back_light")
                            .resizable()
                            .frame(width: 40, height: 40, alignment: .center)
                    }
                    
                    Spacer()
                    
                    Button {
                        viewModel.manageLike()
                    } label: {
                        Image(viewModel.isLiked ? "ic_like_light" : "ic_uklike_light")
                            .resizable()
                            .frame(width: 40, height: 40, alignment: .center)
                    }
                    
                    Button {
                        print("Share")
                    } label: {
                        Image("ic_share_light")
                            .resizable()
                            .frame(width: 40, height: 40, alignment: .center)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
        }
        .frame(width: screenWidth)
        .navigationDestination(isPresented: $viewModel.isShowCastDetails) {
            CelebrityDetailsScreen(viewModel: CelebrityDetailsViewModel(celebrityId: viewModel.selectedCelebrityId))
        }
        .navigationDestination(isPresented: $viewModel.isShowPoster) {
            PosterScreen(viewModel: PosterViewModel(images: viewModel.movieImage?.posters ?? [], isImage: true))
        }
        .navigationDestination(isPresented: $viewModel.isShowVideo) {
            PosterScreen(viewModel: PosterViewModel(video: viewModel.movieVideo?.results ?? [], isImage: false))
        }
        .navigationDestination(isPresented: $viewModel.isShowPosterDetail) {
            PosterDetailScreen(viewModel: PosterDetailsViewModel(images: viewModel.movieImage?.posters ?? []), position: viewModel.posterIndex)
        }
        .defaultPage()
        .sheet(isPresented: $viewModel.isShowAllCast) {
            VStack {
                HStack {
                    Button {
                        viewModel.isShowAllCast = false
                    } label: {
                        Image("ic_cancel")
                            .resizable()
                            .frame(width: 40, height: 40, alignment: .center)
                    }
                    
                    let header = viewModel.selectedCastOption == 0 ? "'s Cast" : "'s Crew"
                    Text("\(viewModel.movieDetail?.title ?? viewModel.movieDetail?.name ?? "") \(header)")
                        .font(.system(size: 21, weight: .semibold))
                        .lineLimit(1)
                    
                    Spacer()
                }
                .padding(.vertical, 5)
                .padding(.horizontal, 16)
                
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: columns) {
                        if viewModel.selectedCastOption == 0 {
                            if let cast = viewModel.movieCredits?.cast, !cast.isEmpty {
                                ForEach(cast.indices, id: \.self) { index in
                                    let cast = cast[index]
                                    MovieDetailsDesign.CastDetail(image: cast.profilePath ?? "", firstName: cast.name, lastName: cast.character)
                                        .onTapGesture {
                                            viewModel.isShowAllCast = false
                                            viewModel.selectedCelebrityId = cast.id
                                            viewModel.isShowCastDetails = true
                                        }
                                }
                            } else {
                                Text("No Cast Found")
                                    .font(.system(size: 21, weight: .bold))
                                    .foregroundColor(.whiteColour)
                            }
                        } else {
                            if let crew = viewModel.movieCredits?.crew, !crew.isEmpty{
                                ForEach(crew.indices, id: \.self) { index in
                                    let crew = crew[index]
                                    MovieDetailsDesign.CastDetail(image: crew.profilePath ?? "", firstName: crew.name, lastName: crew.department)
                                        .onTapGesture {
                                            viewModel.isShowAllCast = false
                                            viewModel.selectedCelebrityId = crew.id
                                            viewModel.isShowCastDetails = true
                                        }
                                }
                            } else {
                                Text("No Crew Found")
                                    .font(.system(size: 21, weight: .bold))
                                    .foregroundColor(.whiteColour)
                            }
                            
                        }
                    }
                }
            }
        }
        
    }
}

#Preview {
    MovieDetails(viewModel: MovieDetailViewModel())
}

class MovieDetailsDesign {
    
    struct WatchItems: View {
        let mediaTab: [String]
        @State var selectedTabIndex: Int = 0
        var onSelect: ((Int)->Void)?
        var onViewAll: (()->Void)?
        
        var isShowShowMore = true
        
        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    ForEach(mediaTab.indices, id: \.self) { index in
                        CelebrityDetails.WatchInfo(itemName: mediaTab[index], isSelected: self.selectedTabIndex == index)
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    self.selectedTabIndex = index
                                    self.onSelect?(self.selectedTabIndex)
                                }
                            }
                            .transition(.slide)
                    }
                    
                    Spacer()
                    
                    if isShowShowMore {
                        Button {
                            self.onViewAll?()
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
    
    struct CastDetail: View {
        let image: String
        let firstName: String
        let lastName: String
        
        var size: CGFloat {
            return (screenWidth-60)/3
        }
        var body: some View {
            VStack(alignment: .leading) {
                ZStack {
                    KFImage.url(URL(string: imageUrl+image))
                        .placeholder({ progress in
                            Image("img_nopeople")
                                .resizable()
                                .scaledToFill()
                        })
                        .resizable()
                        .scaledToFill()
                }
                .frame(width: size, height: size, alignment: .center)
                .background()
                .cornerRadius(14)
                
                Text(firstName)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.whiteColour)
                    .lineLimit(1)
                
                Text(lastName)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.grayColour)
                    .lineLimit(1)
            }
            .frame(width: size)
        }
    }
    
    struct PosterMedia: View {
        var isImage = true
        var image: String
        
        var width: CGFloat {
            return (screenWidth-35)/2
        }
        var height: CGFloat {
            return width*0.8
        }
        
        var body: some View {
            ZStack {
                let url = isImage ? imageUrl+image : "https://img.youtube.com/vi/\(image)/hqdefault.jpg"
                KFImage.url(URL(string: url))
                    .placeholder({ progress in
                        let placeHolderImage = isImage ? "img_noimage" : "img_noimage"
                        Image(placeHolderImage)
                            .resizable()
                            .scaledToFill()
                    })
                    .resizable()
                    .scaledToFill()
                    
                if !isImage {
                    Image("ic_play")
                        .resizable()
                        .frame(width: 30, height: 30)
                }
            }
            .frame(width: width, height: height, alignment: .center)
            .background(.grayColour)
            .cornerRadius(10)
        }
    }
}
