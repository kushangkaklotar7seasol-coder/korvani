//
//  SettingScreen.swift
//  Korvani
//
//  Created by Kushang kaklotar on 20/07/26.
//

import SwiftUI

struct SettingScreen: View {
    @StateObject var viewModel = SettingViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                DefaultDesign.Header(name: "Setting", isShowBackButton: false)
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(viewModel.settingItem, id: \.id) { item in
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .foregroundColor(.grayColour)
                                    .font(.system(size: 14, weight: .semibold))
                                
                                ForEach(item.items, id: \.id) { field in
                                    HStack {
                                        Image(field.language)
                                            .resizable()
                                            .frame(width: 30, height: 30, alignment: .center)
                                        
                                        Text(field.name)
                                            .foregroundColor(.whiteColour)
                                            .font(.system(size: 14, weight: .regular))
                                        
                                        Spacer()
                                    }
                                    .padding()
                                    .background(.lightBlackColour)
                                    .cornerRadius(10)
                                    .onTapGesture {
                                        viewModel.onSelect(item.id)
                                    }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 16)
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .defaultPage()
        .navigationDestination(isPresented: $viewModel.isShowLanguage) {
            LanguageScreen(isShowBackButton: true)
        }
    }
}

#Preview {
    SettingScreen()
}
