//
//  HomeScreen.swift
//  Korvani
//
//  Created by Kushang kaklotar on 10/07/26.
//

import SwiftUI
import Combine
import Kingfisher

struct HomeScreen: View {
    @StateObject var viewModel = HomeViewModel()
    @EnvironmentObject var localization: LocalizationManager
    @State var refreshID = UUID()
    @EnvironmentObject var adVm: AdCountViewModel
    
    var body: some View {
        ZStack {
            VStack {
                Home.Header(viewModel: viewModel)
                
                ScrollView(showsIndicators: false) {
                    VStack {
                        PagerViewIOS17(viewModel: viewModel)
                        
                        if !isPro && (nativeId != "" || nativeId != "ca" ) {
                            NativeAd9()
                                .padding(.vertical, 8)
                        }
                        
                        VStack(spacing: 24) {
                            ForEach(viewModel.moviesBunch, id: \.id) { item in
                                MovieDetail.MediaBunchView(item: item,
                                                           onViewAll: {
                                    viewModel.selectedBunch = item
                                    viewModel.isShowCategoryScreen = true
                                    adVm.registerTap()
                                    logAnalyticAction(title: "", status: AnalyticEvent.Home)
                                }, onMovie: { movie in
                                    viewModel.selectedMovieId = movie.id
                                    viewModel.isSelectedMovie = movie.title != nil ? true : false
                                    viewModel.navigationItem.movieDetail = true
                                    logAnalyticAction(title: "", status: AnalyticEvent.Home)
                                    adVm.registerTap()
                                })
                            }
                        }
                        .padding(.bottom, 24)

                        VStack {
                            HStack {
                                Text(Strings.aboutCelebrity)
                                    .font(.system(size: 18, weight: .semibold))
                                
                                Spacer()
                                
                                Button {
                                    adVm.registerTap()
                                    viewModel.navigationItem.celebrity = true
                                    logAnalyticAction(title: "", status: AnalyticEvent.Home)
                                } label: {
                                    Text(Strings.viewAll)
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
                                                    adVm.registerTap()
                                                    viewModel.navigationItem.celebrityDetail = true
                                                    viewModel.celebritySelectedId = array[index].id
                                                    logAnalyticAction(title: "", status: AnalyticEvent.Home)
                                                }
                                        }
                                    }
                                    .padding(.horizontal, 16)
                                }
                            }
                        }
                        .padding(.top, 8)
                        .id(refreshID)
                        
                        VStack(alignment: .leading) {
                            HStack {
                                Text(Strings.smartHub)
                                    .font(.system(size: 20,weight: .semibold))
                                    .foregroundColor(.whiteColour)
                                
                                Spacer()
                            }
                            
//                            ZStack {
//                                LinearGradient(colors: [.grayColour, .grayColour], startPoint: .topLeading, endPoint: .bottomTrailing)
//                                
//                                if viewModel.locationStaus == 0 {
//                                    Button {
//                                        viewModel.navigationItem.weather = true
//                                    } label: {
//                                        Home.Weather(viewModel: viewModel)
//                                    }
//                                } else if viewModel.locationStaus == 1 || viewModel.locationStaus == 2 {
//                                    Button {
//                                        viewModel.openAppSettings()
//                                    } label: {
//                                        VStack {
//                                           Text(Strings.appPermissionNotGive)
//                                            Text("Open Setting")
//                                        }
//                                    }
//                                }
//                            }
//                            .frame(width: screenWidth-32, height: 120, alignment: .center)
//                            .cornerRadius(20)
                            
                            Home.UnitTranslaterView(viewModel: viewModel)
//                                .id(refreshID)
                            
                            Button {
                                adVm.registerTap()
                                viewModel.navigationItem.wallpaper = true
                                logAnalyticAction(title: "", status: AnalyticEvent.Home)
                            } label: {
                                Home.HdWallpaperView()
                            }
//                            .id(refreshID)
                        }
                        .padding(.horizontal, 16)
                        Spacer()
                    }
                }
            }
        }
        .defaultPage()
        .id(localization.selectedLanguage)
//        .id(orientation.isLandscape)
//        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
//            refreshID = UUID()
//            orientation = UIDevice.current.orientation
//        }
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
            MovieDetails(viewModel: MovieDetailViewModel(movieId: viewModel.selectedMovieId, isMovie: viewModel.isSelectedMovie))
        }
        .navigationDestination(isPresented: $viewModel.isShowCategoryScreen) {
            CategoryListScreen(viewModel: CategoryListViewModel(media: viewModel.selectedBunch))
        }
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
            refreshID = UUID()
        }
        .onAppear() {
            SwipeBackManager.shared.isEnabled = false
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
                    Text(Strings.welcome)
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
                        logAnalyticAction(title: "", status: AnalyticEvent.Home)
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
//        @State private var refreshID = UUID()
        @EnvironmentObject var adVm: AdCountViewModel

        var body: some View {
            HStack() {
                
                Button {
                    adVm.registerTap()
                    viewModel.navigationItem.unitConverter = true
                    logAnalyticAction(title: "", status: AnalyticEvent.Home)
                } label: {
                    ZStack(alignment: .leading) {
                        LinearGradient(colors: [.litePurpleColour, .purpleColour], startPoint: .topLeading, endPoint: .bottomTrailing)
                        
                        VStack(alignment: .leading) {
                            Image("ic_unit_converter")
                                .resizable()
                                .frame(width: 40, height: 40, alignment: .center)
                                .padding(.top, 16)
                            
                            
                            VStack(alignment: .leading, spacing: 3) {
                                Text(Strings.unitConverter)
                                    .font(.system(size: 16, weight: .semibold))
                                    .padding(.top, 9)
                                
                                Text(Strings.unitConverterTagline)
                                    .font(.system(size: 13, weight: .regular))
                            }
                            Spacer()
                        }
                        .padding(.leading, 16)
                    }
                    .frame(height: 120, alignment: .center)
                    .cornerRadius(20)
                }
                
                Button {
                    adVm.registerTap()
                    viewModel.navigationItem.translater = true
                    logAnalyticAction(title: "", status: AnalyticEvent.Home)
                } label: {
                    ZStack(alignment: .leading) {
                        LinearGradient(colors: [.lightGreenColour, .greenColour], startPoint: .topLeading, endPoint: .bottomTrailing)
                        
                        VStack(alignment: .leading) {
                            Image("ic_translate")
                                .resizable()
                                .frame(width: 40, height: 40, alignment: .center)
                                .padding(.top, 16)
                                
                            
                            VStack(alignment: .leading, spacing: 3) {
                                Text(Strings.translate)
                                    .font(.system(size: 16, weight: .semibold))
                                    .padding(.top, 9)
                                
                                Text(Strings.translateTagline)
                                    .font(.system(size: 13, weight: .regular))
                            }
                            Spacer()
                        }
                        .padding(.leading, 16)
                    }
                    .frame(height: 120, alignment: .center)
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
                            Text(Strings.wallpapers)
                                .font(.system(size: 16, weight: .semibold))
                                .padding(.top, 9)
                            
                            Text(Strings.wallpapersTagline)
                                .font(.system(size: 13, weight: .regular))
                        }
                        
                        Spacer()
                    }
                    .padding(.leading, 16)
                    
                    Spacer()
                    
                    Image("img_hdwallpaper")
                }
            }
            .frame(height: 120, alignment: .center)
            .cornerRadius(20)

        }
    }
}


struct MyView: View {
    var body: some View {
        ZStack {
            
        }
        .frame(width: screenWidth * 0.8, height: Device.isIpad ? 320 : 177)
        .background(.white)
    }
}

struct PagerViewIOS17: View {
    let pages: [Color] = [.red, .blue, .green, .orange, .purple]
    @StateObject var viewModel: HomeViewModel
    @EnvironmentObject var adVm: AdCountViewModel
    @StateObject var pagerState = PagerState()
    @State private var timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    var cardWidth: CGFloat {
        if Device.isiPadPortrait {
            return screenWidth * 0.70
        } else if Device.isiPadLandscape {
            return screenWidth * 0.60
        } else {
            return screenWidth * 0.70
        }
    }
    
    var cardHeight: CGFloat {
        if Device.isIpad {
            return screenHeight * 0.35
        } else if Device.isiPadLandscape {
            return screenHeight * 0.50
        } else {
            return screenHeight * 0.18
        }
    }

    private var sidePadding: CGFloat {
        (screenWidth - cardWidth) / 2
    }

    @State private var currentIndex: Int = 500
    
    var body: some View {
        if #available(iOS 17.0, *) {
            Group {
                if !viewModel.topRatedMovie.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 12) {
                            ForEach(0..<1000, id: \.self) { index in
                                let pageIndex = index % viewModel.topRatedMovie.count
                                let movie = viewModel.topRatedMovie[pageIndex]
                                let isCurrent = (pagerState.currentScrolledID ?? 500) == index
                                
                                VStack(alignment: .leading, spacing: 6) {
                                    ZStack {
                                        KFImage.url(URL(string: imageUrl + (movie.posterPath ?? "")))
                                            .resizable()
                                            .scaledToFill()
                                    }
                                    .frame(width: cardWidth, height: cardHeight)
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .clipped()
                                    
                                    if isCurrent {
                                        Text(movie.title)
                                            .font(.system(size: Device.isIpad ? 18 : 15, weight: .medium))
                                            .lineLimit(1)
                                        
                                        HStack(spacing: 4) {
                                            Text("\(movie.releaseDate)  |")
                                                .font(.system(size: Device.isIpad ? 14 : 12, weight: .medium))
                                                .foregroundColor(.grayColour)
                                            
                                            Image("ic_star")
                                                .resizable()
                                                .frame(width: 14, height: 14)
                                            
                                            Text("\(movie.voteAverage / 2)".prefix(3))
                                                .font(.system(size: Device.isIpad ? 14 : 12, weight: .medium))
                                                .foregroundColor(.yellowColour)
                                        }
                                    } else {
                                        Color.clear
                                            .frame(height: Device.isIpad ? 45 : 35)
                                    }
                                }
                                .scrollTransition { content, phase in
                                    content
                                        .scaleEffect(phase.isIdentity ? 1.0 : 0.85)
                                        .opacity(phase.isIdentity ? 1.0 : 0.6)
                                }
                                .id(index)
                                .onTapGesture {
                                    viewModel.selectedMovieId = movie.id
                                    viewModel.navigationItem.movieDetail = true
                                    viewModel.isSelectedMovie = true
                                    logAnalyticAction(title: "", status: AnalyticEvent.Home)
                                    adVm.registerTap()
                                }
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .contentMargins(.horizontal, sidePadding, for: .scrollContent)
                    .scrollTargetBehavior(.viewAligned)
                    .scrollPosition(id: $pagerState.currentScrolledID)
                    .onReceive(timer) { _ in
                        withAnimation(.easeInOut(duration: 0.6)) {
                            let current = pagerState.currentScrolledID ?? 500
                            pagerState.currentScrolledID = current + 1
                        }
                    }
                    .onChange(of: screenWidth) { _, _ in
                        let savedID = pagerState.currentScrolledID
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                            pagerState.currentScrolledID = savedID
                        }
                    }
                } else {
                    ZStack { }
                        .frame(width: cardWidth, height: cardHeight, alignment: .center)
                        .background(Color.gray.opacity(0.4))
                        .cornerRadius(10)
                        .shimmer()
                }
            }
        } else {
            Group {
                if !viewModel.topRatedMovie.isEmpty {
                    VStack(spacing: 0) {
                        GeometryReader { geo in
                            // Peek amount - baju ma keteli card dikhse
                            let sidePeek: CGFloat = Device.isIpad ? 30 : 20
                            
                            TabView(selection: $currentIndex) {
                                ForEach(0..<10000, id: \.self) { index in
                                    let pageIndex = index % viewModel.topRatedMovie.count
                                    let movie = viewModel.topRatedMovie[pageIndex]
                                    let isCurrent = currentIndex == index
                                    
                                    VStack(alignment: .leading, spacing: 8) {
                                        KFImage.url(URL(string: imageUrl + (movie.posterPath ?? "")))
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: cardWidth, height: cardHeight)
                                            .background(Color.white)
                                            .cornerRadius(10)
                                            .clipped()
                                        
                                        if isCurrent {
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(movie.title)
                                                    .font(.system(size: Device.isIpad ? 18 : 15, weight: .medium))
                                                    .lineLimit(1)
                                                
                                                HStack(spacing: 4) {
                                                    Text("\(movie.releaseDate)  |")
                                                        .font(.system(size: Device.isIpad ? 14 : 12, weight: .medium))
                                                        .foregroundColor(.grayColour)
                                                    
                                                    Image("ic_star")
                                                        .resizable()
                                                        .frame(width: 14, height: 14)
                                                    
                                                    Text(String(format: "%.1f", movie.voteAverage / 2))
                                                        .font(.system(size: Device.isIpad ? 14 : 12, weight: .medium))
                                                        .foregroundColor(.yellowColour)
                                                }
                                            }
                                            .frame(width: cardWidth, alignment: .leading)
                                        } else {
                                            Color.clear
                                                .frame(width: cardWidth, height: Device.isIpad ? 45 : 35)
                                        }
                                    }
                                    // MARK: - Simple animation jyare current card change thay
                                    .scaleEffect(isCurrent ? 1.0 : 0.9)
                                    .opacity(isCurrent ? 1.0 : 0.55)
                                    .animation(.easeInOut(duration: 0.28), value: currentIndex)
                                    .padding(.horizontal, sidePeek) // ← peek gap
                                    .tag(index)
                                    .onTapGesture {
                                        viewModel.selectedMovieId = movie.id
                                        viewModel.navigationItem.movieDetail = true
                                        viewModel.isSelectedMovie = true
                                        logAnalyticAction(title: "", status: AnalyticEvent.Home)
                                        adVm.registerTap()
                                    }
                                }
                            }
                            .tabViewStyle(.page(indexDisplayMode: .never))
                            // MARK: - Container thi pahoda banavi, offset thi center karo → peek effect
                            .frame(width: geo.size.width + sidePeek * 2)
                            .offset(x: -sidePeek)
                        }
                        .frame(height: cardHeight + (Device.isIpad ? 75 : 65))
                    }
                    .onAppear {
                        if currentIndex == 0 {
                            currentIndex = 5000 - (5000 % viewModel.topRatedMovie.count)
                        }
                    }
                    .onReceive(timer) { _ in
                        withAnimation {
                            currentIndex += 1
                        }
                    }
                    .onChange(of: currentIndex) { newIndex in
                        pagerState.currentScrolledID = newIndex
                        
                        if newIndex > 9500 || newIndex < 500 {
                            let count = viewModel.topRatedMovie.count
                            let recentered = 5000 - (5000 % count) + (newIndex % count)
                            DispatchQueue.main.async {
                                var t = Transaction()
                                t.disablesAnimations = true
                                withTransaction(t) {
                                    currentIndex = recentered
                                }
                            }
                        }
                    }
                } else {
                    ZStack { }
                        .frame(width: cardWidth, height: cardHeight, alignment: .center)
                        .background(Color.gray.opacity(0.4))
                        .cornerRadius(10)
                        .shimmer()
                }
            }
        }
    }
}

class PagerState: ObservableObject {
    @Published var currentScrolledID: Int? = 500
}

struct ShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = -0.7

    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geometry in
                    let width = geometry.size.width
                    Rectangle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.white.opacity(0),
                                    Color.white.opacity(0.4),
                                    Color.white.opacity(0)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: width * 1.5)
                        .offset(x: phase * width)
                        .onAppear {
                            withAnimation(
                                Animation.linear(duration: 1.5)
                                    .repeatForever(autoreverses: false)
                            ) {
                                phase = 1.3
                            }
                        }
                }
            )
            .mask(content)
    }
}
