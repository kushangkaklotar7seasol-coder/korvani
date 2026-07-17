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
                                    Text("Movie")
                                        .padding(.vertical, 5)
                                        .padding(.horizontal, 12)
                                        .background(.whiteColour.opacity(0.4))
                                        .cornerRadius(10)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(.whiteColour.opacity(0.5), lineWidth: 1)
                                        )
                                        .padding(.horizontal)
                                    
                                    Text("\(viewModel.movieDetail?.title ?? "")")
                                        .lineLimit(2)
                                        .font(.system(size: 22, weight: .semibold))
                                        .padding(.horizontal)
                                    
                                    HStack {
                                        Text(viewModel.movieDetail?.releaseDate ?? "")
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
                                CelebrityDetails.PersonalInfo(name: "Status", details: "\(viewModel.movieDetail?.status ?? "")", isLast: false)
                                CelebrityDetails.PersonalInfo(name: "Language", details: "\(viewModel.movieDetail?.spokenLanguages.first?.englishName ?? "")", isLast: false)
                                CelebrityDetails.PersonalInfo(name: "Runtime", details: "\(viewModel.movieDetail?.runtime ?? 0)", isLast: false)
                                CelebrityDetails.PersonalInfo(name: "Revenue", details: "\(viewModel.movieDetail?.revenue ?? 0)", isLast: true)
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
                    }, isShowShowMore: false)
                    
                    if viewModel.selectedCastOption == 0 {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(viewModel.movieCredits?.cast ?? [], id: \.id) { cast in
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
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(viewModel.movieCredits?.crew ?? [], id: \.id) { crew in
                                    MovieDetailsDesign.CastDetail(image: crew.profilePath ?? "", firstName: crew.name, lastName: crew.department)
                                        .onTapGesture {
                                            viewModel.selectedCelebrityId = crew.id
                                            viewModel.isShowCastDetails = true
                                        }
                                }
                            }
                            .padding(.horizontal)
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
                        ScrollView(.horizontal, showsIndicators: false) {
                            let array = viewModel.movieImage?.posters ?? []
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
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(viewModel.movieVideo?.results ?? [], id: \.key) { video in
                                    MovieDetailsDesign.PosterMedia(isImage: false, image: video.key)
                                        .onTapGesture {
                                            viewModel.openInYouTubeApp(videoID: video.key)
                                        }
                                }
                            }
                            .padding(.horizontal)
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
