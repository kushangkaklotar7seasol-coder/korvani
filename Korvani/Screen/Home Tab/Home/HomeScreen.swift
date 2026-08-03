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
                        
                        if isShowAdd() {
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
                                }, onMovie: { movie in
                                    viewModel.selectedMovieId = movie.id
                                    viewModel.isSelectedMovie = movie.title != nil ? true : false
                                    viewModel.navigationItem.movieDetail = true
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
        .onAppear() {
//            viewModel.onApper()
            SwipeBackManager.shared.isEnabled = false
        }
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
    
//    struct PagerView: View {
//        @StateObject var viewModel: HomeViewModel
//        var cardWidth: CGFloat { screenWidth * 0.8 }
//        var spacing: CGFloat = 16
//        @State var scrollPosition: Int? = 0
//        
//        // Auto-scroll timer
//        let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
//        
//        var body: some View {
//            ScrollView(.horizontal, showsIndicators: false) {
//                HStack(spacing: spacing) {
//                    ForEach(viewModel.topRatedMovie.indices, id: \.self) { index in
//                        VStack(alignment: .leading) {
//                            ZStack {
//                                KFImage.url(URL(string: imageUrl + (viewModel.topRatedMovie[index].posterPath ?? "")))
//                                    .resizable()
//                                    .scaledToFill()
//                            }
//                            .frame(width: cardWidth, height: self.isSelected(index) ? isiPad ? 354 : 177 : isiPad ? 300 : 150)
//                            .background(.white)
//                            .cornerRadius(10)
//                            .animation(.easeInOut(duration: 0.5), value: scrollPosition)
//                            
//                            Text(viewModel.topRatedMovie[index].title)
//                                .font(.system(size: 15, weight: .medium))
//                                .animation(.easeInOut(duration: 0.5), value: scrollPosition)
//                            
//                            HStack(spacing: 0) {
//                                Text("\(viewModel.topRatedMovie[index].releaseDate)   |")
//                                    .font(.system(size: 12, weight: .medium))
//                                    .foregroundColor(.grayColour)
//                                    .padding(.trailing, 8)
//                                
//                                Image("ic_star")
//                                    .frame(width: 14, height: 14, alignment: .center)
//                                
//                                Text("\(viewModel.topRatedMovie[index].voteAverage / 2)".prefix(3))
//                                    .font(.system(size: 12, weight: .medium))
//                                    .foregroundColor(.yellowColour)
//                            }
//                            .animation(.easeInOut(duration: 0.5), value: scrollPosition)
//                        }
//                        .id(index)
//                        .onTapGesture {
//                            viewModel.selectedMovieId = viewModel.topRatedMovie[index].id
//                            viewModel.navigationItem.movieDetail = true
//                        }
//                    }
//                }
//                .scrollTargetLayout()
//            }
//            .safeAreaPadding(.horizontal, (screenWidth - cardWidth) / 2)
//            .scrollTargetBehavior(.viewAligned)
//            .scrollPosition(id: $scrollPosition)
//            .frame(height: isiPad ? 460 : 230)
//            .onAppear {
//                DispatchQueue.main.async {
//                    if scrollPosition == 0 {
//                        scrollPosition = 250
//                    }
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
//            withAnimation(.spring(response: 0.5, dampingFraction: 0.75, blendDuration: 0.3)) {
//                scrollPosition = next
//            }
//        }
//    }
    

    struct AppLayout {
        static var bounds: CGRect {
            UIScreen.main.bounds
        }
        
        // Check if device is in Landscape
        static var isLandscape: Bool {
            bounds.width > bounds.height
        }
        
        // Real Dynamic Width
        static var screenWidth: CGFloat {
            bounds.width
        }
        
        // Dynamic Card Width Calculation
        static var cardWidth: CGFloat {
            if isiPad {
                // iPad Landscape mode -> 50% screen, Portrait -> 65% screen
                return isLandscape ? screenWidth * 0.5 : screenWidth * 0.65
            } else {
                // iPhone
                return screenWidth * 0.8
            }
        }
        
        // Dynamic Pager Height
        static var pagerHeight: CGFloat {
            if isiPad {
                return isLandscape ? 380 : 420
            } else {
                return 230
            }
        }
    }
    
    
    struct PagerView: View {
        @StateObject var viewModel: HomeViewModel
        var spacing: CGFloat = 16
        @State private var scrollPosition: Int? = 0
        
        // Auto-scroll timer
        let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
        
        // Dynamic Side Padding for Centering Active Card
        private var sidePadding: CGFloat {
            (AppLayout.screenWidth - AppLayout.cardWidth) / 2
        }
        
        var body: some View {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: spacing) {
                    ForEach(viewModel.topRatedMovie.indices, id: \.self) { index in
                        VStack(alignment: .leading, spacing: 6) {
                            ZStack {
                                KFImage.url(URL(string: imageUrl + (viewModel.topRatedMovie[index].posterPath ?? "")))
                                    .resizable()
                                    .scaledToFill()
                            }
                            .frame(
                                width: AppLayout.cardWidth,
                                height: self.isSelected(index) ? (isiPad ? 320 : 177) : (isiPad ? 280 : 150)
                            )
                            .background(Color.white)
                            .cornerRadius(10)
                            .clipped()
                            
                            Text(viewModel.topRatedMovie[index].title)
                                .font(.system(size: isiPad ? 18 : 15, weight: .medium))
                                .lineLimit(1)
                            
                            HStack(spacing: 4) {
                                Text("\(viewModel.topRatedMovie[index].releaseDate)  |")
                                    .font(.system(size: isiPad ? 14 : 12, weight: .medium))
                                    .foregroundColor(.grayColour)
                                
                                Image("ic_star")
                                    .resizable()
                                    .frame(width: 14, height: 14)
                                
                                Text("\(viewModel.topRatedMovie[index].voteAverage / 2)".prefix(3))
                                    .font(.system(size: isiPad ? 14 : 12, weight: .medium))
                                    .foregroundColor(.yellowColour)
                            }
                        }
                        .id(index)
                        .onTapGesture {
                            viewModel.selectedMovieId = viewModel.topRatedMovie[index].id
                            viewModel.navigationItem.movieDetail = true
                            viewModel.isSelectedMovie = true
                        }
                    }
                }
                .scrollTargetLayout()
            }
            .safeAreaPadding(.horizontal, sidePadding)
            .scrollTargetBehavior(.viewAligned)
            .scrollPosition(id: $scrollPosition)
            .frame(height: AppLayout.pagerHeight)
            .animation(.easeInOut(duration: 0.3), value: scrollPosition)
            .onAppear {
                if scrollPosition == nil {
                    scrollPosition = 250
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
            withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
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
//        @State private var refreshID = UUID()
        @EnvironmentObject var adVm: AdCountViewModel

        var body: some View {
            HStack() {
                
                Button {
                    adVm.registerTap()
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

    var body: some View {
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
