//
//  TabBarScreen.swift
//  Korvani
//
//  Created by Kushang kaklotar on 15/07/26.
//

import SwiftUI

enum TabItem: CaseIterable {
    case home
    case search
    case favorites
    case profile

    var icon: String {
        switch self {
        case .home: return "ic_home"
        case .search: return "ic_movies"
        case .favorites: return "ic_puzzle"
        case .profile: return "ic_setting"
        }
    }
}

struct TabBarScreen: View {
    @State private var selectedTab: TabItem = .home
    
    var body: some View {
        VStack(spacing: 0) {
            
            ZStack {
                switch selectedTab {
                case .home:
                    HomeScreen()

                case .search:
                    TranslateScreen()

                case .favorites:
                    UnitConverterScreen()

                case .profile:
                    LanguageScreen()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            Divider()
                .background(.tabbarBorderColour)
            
            CustomTabBar(selectedTab: $selectedTab)
        }
        .ignoresSafeArea(.keyboard)
        .background(.tabbarBackgroundColour)
    }
}

#Preview {
    TabBarScreen()
}

struct CustomTabBar: View {

    @Binding var selectedTab: TabItem

    var body: some View {

        HStack {

            ForEach(TabItem.allCases, id: \.self) { tab in

                Button {

                    withAnimation(.spring()) {
                        selectedTab = tab
                    }

                } label: {
                    
                    ZStack() {
                        Image(tab.icon)
                            .resizable()
                            .renderingMode(.template)
                            .tint(selectedTab == tab ? .whiteColour : .grayColour)
                            .frame(width: 24, height: 24, alignment: .center)
                    }
                    .padding(16)
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
                .padding(.top, 5)
            }
        }
//        .background(.blackColour)
        .padding(.horizontal, 10)
//        .padding(.bottom, 5)
    }
}
