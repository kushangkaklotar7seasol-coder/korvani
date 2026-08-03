//
//  TabBarScreen.swift
//  Korvani
//
//  Created by Kushang kaklotar on 15/07/26.
//

import SwiftUI

enum TabItem: CaseIterable {
    case home
    case movies
    case puzzle
    case setting

    var icon: String {
        switch self {
        case .home: return "ic_home"
        case .movies: return "ic_movies"
        case .puzzle: return "ic_puzzle"
        case .setting: return "ic_setting"
        }
    }
}

import SwiftUI

//struct TabBarScreen: View {
//    @State private var selectedTab: TabItem = .home
//    
//    var body: some View {
//        VStack(spacing: 0) {
//            // Main Active View Container
//            Group {
//                switch selectedTab {
//                case .home:
//                    HomeScreen()
//                case .movies:
//                    DiscoverScreen()
//                case .puzzle:
//                    PuzzleView(viewModel: PuzzleViewModel())
//                case .setting:
//                    SettingScreen()
//                }
//            }
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//            
//            Divider()
//                .background(Color.tabbarBorderColour)
//            
//            // Custom TabBar
//            CustomTabBar(selectedTab: $selectedTab)
//                .background(Color.tabbarBackgroundColour)
//        }
//        .background(Color.blackColour)
//        .ignoresSafeArea(.keyboard)
//        // Ensure status bar & navigation doesn't push down
//        .navigationBarHidden(true)
//        .toolbar(.hidden, for: .navigationBar)
//    }
//}

struct TabBarScreen: View {
    @State private var selectedTab: TabItem = .home
    
    // ViewModel ને એક જ વાર ઇનિશિયલાઇઝ કરવા માટે સ્ટેટ પ્રોપર્ટી વાપરો
    @StateObject private var puzzleViewModel = PuzzleViewModel()
    @State private var loadedTabs: Set<TabItem> = [.home]
    
    var body: some View {
        VStack(spacing: 0) {
            // Main Active View Container using ZStack
            ZStack {
//                FScreen1()
                if loadedTabs.contains(.home) {
                    HomeScreen()
                        .opacity(selectedTab == .home ? 1 : 0)
                        .allowsHitTesting(selectedTab == .home)
                }
                
                if loadedTabs.contains(.movies) {
                    DiscoverScreen()
                        .opacity(selectedTab == .movies ? 1 : 0)
                        .allowsHitTesting(selectedTab == .movies)
                }
                
                if loadedTabs.contains(.puzzle) {
                    PuzzleView(viewModel: puzzleViewModel)
                    //   FScreen3()
                        .opacity(selectedTab == .puzzle ? 1 : 0)
                        .allowsHitTesting(selectedTab == .puzzle)
                }
                
                if loadedTabs.contains(.setting) {
                    SettingScreen()
                    //    FScreen4()
                        .opacity(selectedTab == .setting ? 1 : 0)
                        .allowsHitTesting(selectedTab == .setting)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Divider()
                .background(Color.tabbarBorderColour)
            
            // Custom TabBar
            CustomTabBar(selectedTab: $selectedTab, loadedTabs: $loadedTabs)
                .background(Color.tabbarBackgroundColour)
        }
        .background(Color.blackColour)
        .ignoresSafeArea(.keyboard)
        
        .navigationBarHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: TabItem
    @Binding var loadedTabs: Set<TabItem>
    
    var body: some View {
        HStack {
            ForEach(TabItem.allCases, id: \.self) { tab in
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = tab
                    }
                    if !loadedTabs.contains(tab) {
                        loadedTabs.insert(tab)
                    }
                } label: {
                    ZStack {
                        Image(tab.icon)
                            .resizable()
                            .renderingMode(.template)
                            .tint(selectedTab == tab ? .whiteColour : .grayColour)
                            .frame(width: 24, height: 24)
                    }
                    .padding(12) // Slightly reduced padding for landscape safety
                    .background(
                        LinearGradient(
                            colors: [selectedTab == tab ? .lightYellowColour : .clear, selectedTab == tab ? .orangeColour: .clear],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(32)
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
    }
}

//struct TabBarScreen: View {
//    @State private var selectedTab: TabItem = .home
//    
//    var body: some View {
//        VStack(spacing: 0) {
//            
//            ZStack {
//                HomeScreen()
//                    .opacity(selectedTab == .home ? 1 : 0)
//                
//                DiscoverScreen()
//                    .opacity(selectedTab == .movies ? 1 : 0)
//                
//                PuzzleView(viewModel: PuzzleViewModel())
//                    .opacity(selectedTab == .puzzle ? 1 : 0)
//                
//                SettingScreen()
//                    .opacity(selectedTab == .setting ? 1 : 0)
//            }
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//
//            Divider()
//                .background(.tabbarBorderColour)
//            
//            CustomTabBar(selectedTab: $selectedTab)
//        }
//        .ignoresSafeArea(.keyboard)
//        .background(.tabbarBackgroundColour)
//    }
//}

#Preview {
    TabBarScreen()
}

//struct CustomTabBar: View {
//
//    @Binding var selectedTab: TabItem
//
//    var body: some View {
//
//        HStack {
//
//            ForEach(TabItem.allCases, id: \.self) { tab in
//
//                Button {
//
//                    withAnimation(.spring()) {
//                        selectedTab = tab
//                    }
//
//                } label: {
//                    
//                    ZStack() {
//                        Image(tab.icon)
//                            .resizable()
//                            .renderingMode(.template)
//                            .tint(selectedTab == tab ? .whiteColour : .grayColour)
//                            .frame(width: 24, height: 24, alignment: .center)
//                    }
//                    .padding(16)
//                    .background(
//                        LinearGradient(
//                            colors: [selectedTab == tab ? .lightYellowColour : .clear, selectedTab == tab ? .orangeColour: .clear],
//                            startPoint: .topLeading,
//                            endPoint: .bottomTrailing
//                        )
//                    )
//                    .cornerRadius(32)
//                    .frame(maxWidth: .infinity)
//                }
//                .padding(.top, 5)
//            }
//        }
////        .background(.blackColour)
//        .padding(.horizontal, 10)
////        .padding(.bottom, 5)
//    }
//}
