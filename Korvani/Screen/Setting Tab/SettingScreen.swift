//
//  SettingScreen.swift
//  Korvani
//
//  Created by Kushang kaklotar on 20/07/26.
//

import SwiftUI

struct SettingScreen: View {
    @StateObject var viewModel = SettingViewModel()
    @EnvironmentObject var localization: LocalizationManager
    @EnvironmentObject var adVm: AdCountViewModel
    
    var body: some View {
        ZStack {
            VStack {
                DefaultDesign.Header(name: Strings.setting, isShowBackButton: false)
                    .padding(.horizontal, 16)
                
                ScrollView(showsIndicators: false) {
                    
                    SettingDesign.PremiumView()
                        .onTapGesture {
                            viewModel.isShowPremium = true
                            logAnalyticAction(title: "", status: AnalyticEvent.Setting)
                        }
                    
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(viewModel.settingItem, id: \.id) { item in
                            VStack(alignment: .leading) {
                                Text(item.name.localized())
                                    .foregroundColor(.grayColour)
                                    .font(.system(size: 14, weight: .semibold))
                                
                                ForEach(item.items, id: \.id) { field in
                                    HStack {
                                        Image(field.language)
                                            .resizable()
                                            .frame(width: 30, height: 30, alignment: .center)
                                        
                                        Text(field.name.localized())
                                            .foregroundColor(.whiteColour)
                                            .font(.system(size: 14, weight: .regular))
                                        
                                        Spacer()
                                    }
                                    .padding()
                                    .background(.lightBlackColour)
                                    .cornerRadius(10)
                                    .onTapGesture {
                                        viewModel.onSelect(field.id)
                                    }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 16)
                        .padding(.horizontal, 16)
                    }
                }
                .id(localization.selectedLanguage)
                
                Spacer()
                
                if !isPro && (nativeId != "" || nativeId != "ca" ) {
                    NativeAd9()
                        .padding(.vertical, 8)
                }
            }
        }
        .defaultPage()
        .id(localization.selectedLanguage)
        .navigationDestination(isPresented: $viewModel.isShowLanguage) {
            LanguageScreen(isShowBackButton: true)
        }
        .fullScreenCover(isPresented: $viewModel.isShowPremium) {
            PremiumScreen()
        }
        .onAppear {
            SwipeBackManager.shared.isEnabled = false
        }
    }
}

#Preview {
    SettingScreen()
}

class SettingDesign {
    struct PremiumView: View {
        var body: some View {
            ZStack {
                HStack(spacing: 16) {
                    ZStack {
                        Image("ic_premium")
                            .resizable()
                            .frame(width: 26, height: 26, alignment: .center)
                    }
                    .frame(width: 48, height: 48, alignment: .center)
                    .background(
                        LinearGradient(colors: [.lightYellowColour, .orangeColour], startPoint: .top, endPoint: .bottom)
                    )
                    .cornerRadius(48)
                    .shadow(color: .orangeColour, radius: 20, x: 0.5, y: 0.5)
                    
                    VStack(alignment: .leading) {
                        Text("PREMIUM")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.orangeColour)
                            .padding(.bottom, 5)
                        
                        Text("Unlock Premium")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.whiteColour)
                        
                        Text("Get unlimited access to all premium features.")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(.whiteColour)
                    }
                    
                    Spacer()
                    
                    VStack {
                        Image("ic_left_arrow_orange")
                            .resizable()
                            .frame(width: 24, height: 24, alignment: .center)
                    }
                }
                .padding()
            }
            .frame(maxWidth: .infinity)
            .background(.orangeColour.opacity(0.2))
            .cornerRadius(16)
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(.orangeColour)
            }
            .padding(.horizontal, 16)

        }
    }
}
