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
                                        if field.id == 0 { // For language navigation
                                            adVm.registerTap()
                                        }
                                        viewModel.onSelect(field.id)
                                    }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 16)
                        .padding(.horizontal, 16)
                        
                        if isShowAdd() {
                            NativeAd9()
                                .padding(.vertical, 8)
                        }
                    }
                }
                .id(localization.selectedLanguage)
            }
        }
        .defaultPage()
        .id(localization.selectedLanguage)
        .navigationDestination(isPresented: $viewModel.isShowLanguage) {
            LanguageScreen(isShowBackButton: true)
        }
        .onAppear {
            SwipeBackManager.shared.isEnabled = false
        }
    }
}

#Preview {
    SettingScreen()
}
