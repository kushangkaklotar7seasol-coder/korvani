//
//  HomeScreen.swift
//  Korvani
//
//  Created by Kushang kaklotar on 10/07/26.
//

import SwiftUI
internal import Combine
import Kingfisher

struct HomeScreen: View {
    @StateObject var viewModel = HomeViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                Home.Header(viewModel: viewModel)
                
                ScrollView(showsIndicators: false) {
                    VStack {
                        if !viewModel.topRatedMovie.isEmpty {
                            Home.PagerView(viewModel: viewModel)
                        } else {
                            ZStack { }
                                .frame(width: screenWidth * 0.8, height: 177)
                                .background(.grayColour)
                                .cornerRadius(10)
                                .padding(.bottom, 53)
                        }
                        
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Smart Hub")
                                    .font(.system(size: 20,weight: .semibold))
                                    .foregroundColor(.whiteColour)
                                
                                Spacer()
                            }
                            
                            ZStack {
                                LinearGradient(colors: [.grayColour, .grayColour], startPoint: .topLeading, endPoint: .bottomTrailing)
                                
                                if viewModel.locationStaus == 0 {
                                    Button {
                                        viewModel.navigationItem.weather = true
                                    } label: {
                                        Home.Weather(viewModel: viewModel)
                                    }
                                } else if viewModel.locationStaus == 1 {
                                    Button ("Allow Permission for getting Weather") {
                                        viewModel.openAppSettings()
                                    }
                                } else if viewModel.locationStaus == 2 {
                                    Button ("Allow Permission for getting Weather") {
                                        viewModel.openAppSettings()
                                    }
                                }
                            }
                            .frame(width: screenWidth-32, height: 120, alignment: .center)
                            .cornerRadius(20)
                            
                            Home.UnitTranslaterView(viewModel: viewModel)
                            
                            Button {
                                viewModel.navigationItem.wallpaper = true
                            } label: {
                                Home.HdWallpaperView()
                            }
                        }
                        .padding(.horizontal, 16)
                        
                        VStack {
                            HStack {
                                Text("About the Celebrity")
                                    .font(.system(size: 18, weight: .semibold))
                                
                                Spacer()
                                
                                Button {
                                    print("View all")
                                    viewModel.navigationItem.celebrity = true
                                } label: {
                                    Text("View all")
                                        .foregroundColor(.mediumOrangeColour)
                                        .font(.system(size: 12,weight: .semibold))
                                }
                            }
                            .padding(.horizontal, 16)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                if let array = viewModel.celebrity?.results {
                                    HStack {
                                        ForEach(array.indices, id: \.self) { index in
                                            celebrity.profile(celebrity: array[index])
                                                .onTapGesture {
                                                    viewModel.navigationItem.celebrityDetail = true
                                                    viewModel.celebritySelectedId = array[index].id
                                                }
                                        }
                                    }
                                    .padding(.horizontal, 16)
                                }
                            }
                        }
                        .padding(.top, 24)
                        
                        Spacer()
                    }
                }
            }
            
        }
        .defaultPage()
        .navigationDestination(isPresented: $viewModel.navigationItem.celebrity) {
            CelebrityScreen(viewModel: CelebrityViewModel(celebrity: viewModel.celebrity))
        }
        .navigationDestination(isPresented: $viewModel.navigationItem.celebrityDetail) {
            CelebrityDetailsScreen(viewModel: CelebrityDetailsViewModel(celebrityId: viewModel.celebritySelectedId))
        }
        .navigationDestination(isPresented: $viewModel.navigationItem.weather) {
            Weather()
        }
        .navigationDestination(isPresented: $viewModel.navigationItem.unitConverter) {
            UnitConverterScreen()
        }
        .navigationDestination(isPresented: $viewModel.navigationItem.translater) {
            TranslateScreen()
        }
        .navigationDestination(isPresented: $viewModel.navigationItem.wallpaper) {
            WallpaperScreen()
        }
        .navigationDestination(isPresented: $viewModel.navigationItem.search) {
            SearchScreen()
        }
        .navigationDestination(isPresented: $viewModel.navigationItem.movieDetail) {
            MovieDetails(viewModel: MovieDetailViewModel(movieId: viewModel.selectedMovieId))
        }
        .onAppear() {
            viewModel.onApper()
        }
    }
}

#Preview {
    HomeScreen()
}

class Home {
    
    struct Header: View {
        @StateObject var viewModel: HomeViewModel
        
        var body: some View {
            HStack {
                VStack(alignment: .leading) {
                    Text("Welcome to,")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.grayColour)
                    
                    Text(appName)
                        .font(.system(size: 24, weight: .medium))
                }
                
                Spacer()
                
                if viewModel.isLoading {
                    ProgressView()
                        .tint(.whiteColour)
                        .frame(width: 40, height: 40)
                } else {
                    Button {
                        viewModel.navigationItem.search = true
                    } label: {
                        Image("ic_search")
                            .resizable()
                            .frame(width: 40, height: 40)
                    }
                }
            }
            .padding(.horizontal, 16)

        }
    }
    
    struct PagerView: View {
        @StateObject var viewModel: HomeViewModel
        var cardWidth: CGFloat { screenWidth * 0.8 }
        var spacing: CGFloat = 16
        @State private var scrollPosition: Int?
        
        // Auto-scroll timer
        let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
        
        var body: some View {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: spacing) {
                    ForEach(viewModel.topRatedMovie.indices, id: \.self) { index in
                        VStack(alignment: .leading) {
                            ZStack {
                                KFImage.url(URL(string: imageUrl + (viewModel.topRatedMovie[index].posterPath ?? "")))
                                    .resizable()
                                    .scaledToFill()
                            }
                            .frame(width: cardWidth, height: self.isSelected(index) ? 177 : 150)
                            .background(.white)
                            .cornerRadius(10)
                            .animation(.easeInOut(duration: 0.3), value: scrollPosition)
                            
                            Text(viewModel.topRatedMovie[index].title)
                                .font(.system(size: 15, weight: .medium))
                                .animation(.easeInOut(duration: 0.3), value: scrollPosition)
                            
                            HStack(spacing: 0) {
                                Text("\(viewModel.topRatedMovie[index].releaseDate)   |")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.grayColour)
                                    .padding(.trailing, 8)
                                
                                Image("ic_star")
                                    .frame(width: 14, height: 14, alignment: .center)
                                
                                Text("\(viewModel.topRatedMovie[index].voteAverage / 2)".prefix(3))
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.yellowColour)
                            }
                            .animation(.easeInOut(duration: 0.3), value: scrollPosition)
                        }
                        .id(index)
                        .onTapGesture {
                            viewModel.selectedMovieId = viewModel.topRatedMovie[index].id
                            viewModel.navigationItem.movieDetail = true
                        }
                    }
                }
                .scrollTargetLayout()
            }
            .safeAreaPadding(.horizontal, (screenWidth - cardWidth) / 2)
            .scrollTargetBehavior(.viewAligned)
            .scrollPosition(id: $scrollPosition)
            .frame(height: 230)
            .onAppear {
                DispatchQueue.main.async {
                    scrollPosition = 0
                }
            }
            .onReceive(timer) { _ in
                autoScrollToNext()
            }
        }
        
        private func isSelected(_ index: Int) -> Bool {
            (scrollPosition ?? 0) == index
        }
        
        private func autoScrollToNext() {
            guard !viewModel.topRatedMovie.isEmpty else { return }
            let current = scrollPosition ?? 0
            let next = current < viewModel.topRatedMovie.count - 1 ? current + 1 : 0
            withAnimation(.easeInOut(duration: 0.3)) {
                scrollPosition = next
            }
        }
    }
//    struct PagerView: View {
//        @StateObject var viewModel: HomeViewModel
//        var cardWidth: CGFloat { screenWidth * 0.8 }
//        var spacing: CGFloat = 16
//        @State private var scrollPosition: Int?
//        
//        // Auto-scroll timer
//        let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
//        
//        var body: some View {
//            ScrollView(.horizontal, showsIndicators: false) {
//                HStack(spacing: spacing) {
//                    ForEach(viewModel.topRatedMovie.indices, id: \.self) { index in
//                            VStack(alignment: .leading) {
//                                ZStack {
//                                    KFImage.url(URL(string: imageUrl+(viewModel.topRatedMovie[index].posterPath ?? "")))
//                                        .resizable()
//                                        .scaledToFill()
//                                }
//                                .frame(width: cardWidth, height: self.isSelected(index) ? 177 : 150)
//                                .background(.white)
//                                .cornerRadius(10)
//                                .animation(.easeInOut(duration: 0.3), value: scrollPosition)
//                                
//                                Text(viewModel.topRatedMovie[index].title)
//                                    .font(.system(size: 15, weight: .medium))
//                                    .animation(.easeInOut(duration: 0.3), value: scrollPosition)
//                                
//                                HStack(spacing: 0) {
//                                    Text("\(viewModel.topRatedMovie[index].releaseDate)   |")
//                                        .font(.system(size: 12, weight: .medium))
//                                        .foregroundColor(.grayColour)
//                                        .padding(.trailing, 8)
//                                    
//                                    Image("ic_star")
//                                        .frame(width: 14, height: 14, alignment: .center)
//                                    
//                                    Text("\(viewModel.topRatedMovie[index].voteAverage/2)".prefix(3))
//                                        .font(.system(size: 12, weight: .medium))
//                                        .foregroundColor(.yellowColour)
//                                    
//                                }
//                                .animation(.easeInOut(duration: 0.3), value: scrollPosition)
//                            }
//                            .id(index)
//                    }
//                }
//                .scrollTargetLayout()
//                .padding(.horizontal, (screenWidth - cardWidth) / 2)
//            }
//            .scrollTargetBehavior(.viewAligned)
//            .scrollPosition(id: $scrollPosition)
//            .frame(height: 230)
//            .onAppear {
//                DispatchQueue.main.async {
//                    scrollPosition = 0
//                }
//            }
//            .onReceive(timer) { _ in
//                autoScrollToNext()
//            }
//        }
//        
//        private func isSelected(_ index: Int) -> Bool {
//            (scrollPosition ?? 0) == index
//        }
//        
//        private func autoScrollToNext() {
//            guard !viewModel.topRatedMovie.isEmpty else { return }
//            let current = scrollPosition ?? 0
//            let next = current < viewModel.topRatedMovie.count - 1 ? current + 1 : 0
//            withAnimation(.easeInOut(duration: 0.3)) {
//                scrollPosition = next
//            }
//        }
//    }
    
    struct Weather: View {
        @StateObject var viewModel: HomeViewModel
        
        var body: some View {
            ZStack {
                LinearGradient(colors: [.skyBlueColour, .liteSkyBlueColour], startPoint: .topLeading, endPoint: .bottomTrailing)
                
                HStack {
                    ZStack {
                        KFImage.url(URL(string: Utility.getWeatherImageUrl(viewModel.todayWeather?.weather.first?.icon ?? "")))
                            .resizable()
                            .scaledToFill()
                    }
                    .frame(width: 80, height: 80, alignment: .center)
                    .background(.clear)
                    
                    VStack(alignment: .leading) {
                        Text("\(viewModel.todayWeather?.main.temp ?? 0.0)°".prefix(4))
                            .font(.system(size: 30, weight: .bold))
                        
                        Text(Date.now, format: .dateTime.weekday(.wide).month(.wide).day())
                            .font(.system(size: 14, weight: .regular))
                        
                        Text(locationManager.addressString)
                            .font(.system(size: 14, weight: .semibold))
                            .lineLimit(1)
                    }
                    
                    Spacer()
                    
                    Text(viewModel.todayWeather?.weather.first?.main ?? "")
                        .font(.system(size: 12, weight: .medium))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 5)
                        .background(.white.opacity(0.2))
                        .cornerRadius(20)
                }
                .padding(.horizontal, 16)
            }
            .frame(width: screenWidth-32, height: 120, alignment: .center)
            .cornerRadius(20)

        }
    }
    
    struct UnitTranslaterView: View {
        @StateObject var viewModel: HomeViewModel
        
        var body: some View {
            HStack() {
                
                Button {
                    viewModel.navigationItem.unitConverter = true
                } label: {
                    ZStack(alignment: .leading) {
                        LinearGradient(colors: [.litePurpleColour, .purpleColour], startPoint: .topLeading, endPoint: .bottomTrailing)
                        
                        VStack(alignment: .leading) {
                            Image("ic_unit_converter")
                                .resizable()
                                .frame(width: 40, height: 40, alignment: .center)
                                .padding(.top, 16)
                            
                            
                            VStack(alignment: .leading, spacing: 3) {
                                Text("Unit Converter")
                                    .font(.system(size: 16, weight: .semibold))
                                    .padding(.top, 9)
                                
                                Text("Convert units instantly")
                                    .font(.system(size: 13, weight: .regular))
                            }
                            Spacer()
                        }
                        .padding(.leading, 16)
                    }
                    .frame(width: (screenWidth-32)/2, height: 120, alignment: .center)
                    .cornerRadius(20)
                }
                
                Button {
                    viewModel.navigationItem.translater = true
                } label: {
                    ZStack(alignment: .leading) {
                        LinearGradient(colors: [.lightGreenColour, .greenColour], startPoint: .topLeading, endPoint: .bottomTrailing)
                        
                        VStack(alignment: .leading) {
                            Image("ic_translate")
                                .resizable()
                                .frame(width: 40, height: 40, alignment: .center)
                                .padding(.top, 16)
                                
                            
                            VStack(alignment: .leading, spacing: 3) {
                                Text("Translate")
                                    .font(.system(size: 16, weight: .semibold))
                                    .padding(.top, 9)
                                
                                Text("Instant Translation")
                                    .font(.system(size: 13, weight: .regular))
                            }
                            Spacer()
                        }
                        .padding(.leading, 16)
                    }
                    .frame(width: (screenWidth-32)/2, height: 120, alignment: .center)
                    .cornerRadius(20)
                }
            }
        }
    }
    
    struct HdWallpaperView: View {
        var body: some View {
            ZStack(alignment: .leading) {
                LinearGradient(colors: [.mediumOrangeColour, .lightOrange], startPoint: .topLeading, endPoint: .bottomTrailing)
                
                HStack {
                    VStack(alignment: .leading) {
                        Image("ic_wallpaper")
                            .resizable()
                            .frame(width: 40, height: 40, alignment: .center)
                            .padding(.top, 16)
                        
                        
                        VStack(alignment: .leading, spacing: 3) {
                            Text("HD Wallpapers")
                                .font(.system(size: 16, weight: .semibold))
                                .padding(.top, 9)
                            
                            Text("Browse and download wallpapers")
                                .font(.system(size: 13, weight: .regular))
                        }
                        
                        Spacer()
                    }
                    .padding(.leading, 16)
                    
                    Spacer()
                    
                    Image("img_hdwallpaper")
                }
            }
            .frame(width: screenWidth-32, height: 120, alignment: .center)
            .cornerRadius(20)

        }
    }
}
