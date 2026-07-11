//
//  HomeScreen.swift
//  Korvani
//
//  Created by Kushang kaklotar on 10/07/26.
//

import SwiftUI
internal import Combine

struct HomeScreen: View {
    @StateObject var viewModel = HomeViewModel()
    
    
    var body: some View {
        ZStack {
            VStack {
                Home.Header()
                
                ScrollView(showsIndicators: false) {
                    VStack {
                        Home.PagerView(viewModel: viewModel)
                        
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Smart Hub")
                                    .font(.system(size: 20,weight: .semibold))
                                    .foregroundColor(.whiteColour)
                                
                                Spacer()
                            }
                            
                            Home.Weather()
                            
                            Home.UnitTranslaterView()
                            
                            Home.HdWallpaperView()
                        }
                        .padding(.horizontal, 16)
                        
                        VStack {
                            HStack {
                                Text("About the Celebrity")
                                    .font(.system(size: 18,weight: .semibold))
                                
                                Spacer()
                                
                                Button {
                                    print("View all")
                                } label: {
                                    Text("View all")
                                        .foregroundColor(.mediumOrangeColour)
                                        .font(.system(size: 12,weight: .semibold))
                                }
                            }
                            .padding(.horizontal, 16)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(1...10, id: \.self) { value in
                                        VStack(alignment: .leading) {
                                            ZStack { }
                                                .frame(width: 102, height: 102, alignment: .center)
                                                .background(.whiteColour)
                                                .cornerRadius(12)
                                            
                                            Text("John wichJohn wichJohn wichJohn wich")
                                                .font(.system(size: 14,weight: .regular))
                                                .lineLimit(1)
                                        }
                                        .frame(width: 102)
                                    }
                                }
                                .padding(.horizontal, 16)
                            }
                        }
                        .padding(.top, 24)
                        
                        Spacer()
                    }
                }
            }
            .foregroundColor(.whiteColour)
        }
        .background(.blackColour)
    }
}

#Preview {
    HomeScreen()
}

class Home {
    
    struct Header: View {
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
                
                Button {
                    print("Search")
                } label: {
                    Image("ic_search")
                        .resizable()
                        .frame(width: 40, height: 40)
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
                    ForEach(viewModel.information.indices, id: \.self) { index in
                        VStack(alignment: .leading) {
                            ZStack { }
                                .frame(width: cardWidth, height: self.isSelected(index) ? 177 : 150)
                                .background(.white)
                                .cornerRadius(10)
                                .animation(.easeInOut(duration: 0.3), value: scrollPosition)
                            
                            Text("Once upon a time in Hollywood")
                                .font(.system(size: 15, weight: .medium))
                                .animation(.spring(duration: 0.3), value: scrollPosition)
                            
                            HStack(spacing: 0) {
                                Text("1234  |")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.grayColour)
                                    .padding(.trailing, 8)
                                
                                Image("ic_star")
                                    .frame(width: 14, height: 14, alignment: .center)
                                
                                Text("123")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.yellowColour)
                            }
                            .animation(.spring(duration: 0.3), value: scrollPosition)
                        }
                        .id(index)
                    }
                }
                .scrollTargetLayout()
                .padding(.horizontal, (screenWidth - cardWidth) / 2)
//                .containerRelativeFrame(.horizontal)
            }
            .scrollTargetBehavior(.viewAligned)
            .scrollPosition(id: $scrollPosition)
            .frame(height: 230)
            .onAppear {
                DispatchQueue.main.async {
                    scrollPosition = 0
                }
            }
//            .onReceive(timer) { _ in
//                autoScrollToNext()
//            }
        }
        
        private func isSelected(_ index: Int) -> Bool {
            (scrollPosition ?? 0) == index
        }
        
        private func autoScrollToNext() {
            guard !viewModel.information.isEmpty else { return }
            let current = scrollPosition ?? 0
            let next = current < viewModel.information.count - 1 ? current + 1 : 0
            withAnimation(.easeInOut(duration: 0.3)) {
                scrollPosition = next
            }
        }
    }
    
    struct Weather: View {
        var body: some View {
            ZStack {
                LinearGradient(colors: [.skyBlueColour, .liteSkyBlueColour], startPoint: .topLeading, endPoint: .bottomTrailing)
                
                HStack {
                    ZStack { }
                        .frame(width: 60, height: 60, alignment: .center)
                        .background(.white)
                    
                    VStack(alignment: .leading) {
                        Text("32°")
                            .font(.system(size: 27, weight: .bold))
                        
                        Text("06 May, Wednesday")
                            .font(.system(size: 14, weight: .regular))
                        
                        Text("New York, USA")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    
                    Spacer()
                    
                    Text("Sunny")
                        .font(.system(size: 12, weight: .medium))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 5)
                        .background(.white.opacity(0.2))
                        .cornerRadius(20)
                }
                .padding(.horizontal, 20)
            }
            .frame(width: screenWidth-32, height: 120, alignment: .center)
            .cornerRadius(20)

        }
    }
    
    struct UnitTranslaterView: View {
        var body: some View {
            HStack() {
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
