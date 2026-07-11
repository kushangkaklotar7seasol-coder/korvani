//
//  Splash.swift
//  Korvani
//
//  Created by Kushang kaklotar on 09/07/26.
//

import SwiftUI

struct Splash: View {
    @StateObject var viewModel = SplashViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                Image("ic_app_name")
                    .frame(width: 196)
                
                Text(Strings.splashSubtitle)
                    .foregroundColor(.grayColour)
            }
        }
        .frame(minWidth: screenWidth, minHeight: screenHeight)
        .background(.blackColour)
        .navigationDestination(isPresented: $viewModel.navigation.OnBoding) {
            OnBoding()
                .toolbar(.hidden, for: .navigationBar)
        }
        .navigationDestination(isPresented: $viewModel.navigation.language) {
            LanguageScreen()
                .toolbar(.hidden, for: .navigationBar)
        }
        .navigationDestination(isPresented: $viewModel.navigation.home) {
            HomeScreen()
                .toolbar(.hidden, for: .navigationBar)
        }
    }
}

#Preview {
    Splash()
}
