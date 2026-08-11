//
//  TabBarScreen.swift
//  Korvani
//
//  Created by Kushang kaklotar on 15/07/26.
//

import SwiftUI
import StoreKit

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

struct TabBarScreen: View {
    @State private var selectedTab: TabItem = .home
    @State private var loadedTabs: Set<TabItem> = [.home]
    @State private var showRateAlert = false
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
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
                    PuzzleView()
                        .opacity(selectedTab == .puzzle ? 1 : 0)
                        .allowsHitTesting(selectedTab == .puzzle)
                }
                
                if loadedTabs.contains(.setting) {
                    SettingScreen()
                        .opacity(selectedTab == .setting ? 1 : 0)
                        .allowsHitTesting(selectedTab == .setting)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Divider()
                .background(Color.tabbarBorderColour)
            
            CustomTabBar(selectedTab: $selectedTab, loadedTabs: $loadedTabs)
                .background(Color.tabbarBackgroundColour)
        }
        .background(Color.blackColour)
        .ignoresSafeArea(.keyboard)
        .navigationBarHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            if !AppSession.shared.hasShownRate {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.handlePostReviewLogic()
                    AppSession.shared.hasShownRate = true
                }
            }
        }
        .alert(Strings.likeApp, isPresented: $showRateAlert) {

            Button(Strings.rateNo, role: .cancel) { }
            
            Button(Strings.rateYes) {
                rateApp()
            }
            
        } message: {
            Text(Strings.rateInfo)
        }
    }
    
    func handlePostReviewLogic() {
        let didAskForReview = UserDefaults.standard.bool(forKey: "didAskForReview")

        if didAskForReview {
            print("Review dialog was requested")
            rateApp()
        } else {
            print("Review not requested")
            showRateAlert = true
        }
    }
    
    func rateApp() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            UserDefaults.standard.set(true, forKey: "didAskForReview")
            SKStoreReviewController.requestReview(in: scene)
        }
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

#Preview {
    TabBarScreen()
}
