//
//  LanguageScreen.swift
//  Korvani
//
//  Created by Kushang kaklotar on 10/07/26.
//

import SwiftUI

struct LanguageScreen: View {
    @StateObject var viewModel = LanguageViewModel()
    var isShowBackButton: Bool = false
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var localization: LocalizationManager
    
    let columns = [
        GridItem(.flexible(), spacing: 15),
        GridItem(.flexible(), spacing: 15)
    ]
    
    var body: some View {
        ZStack {
            VStack {
                
                HStack {
                    if isShowBackButton {
                        Button {
                            self.dismiss()
                        } label: {
                            Image("ic_back")
                                .resizable()
                                .frame(width: 40, height: 40, alignment: .center)
                        }
                    }
                    
                    Text("Choose Your\nPreferred Language")
                        .font(.system(size: 20, weight: .semibold))
                    
                    Spacer()
                    
                    Button {
                        viewModel.onDoneButtonClick()
                        localization.changeLanguage(languageCode: viewModel.selectedLanguage?.code ?? "en")
                        if self.isShowBackButton {
                            self.dismiss()
                        } else {
                            viewModel.isOnBording = true
                        }
                    } label: {
                        Text("Done")
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(
                                LinearGradient( colors: [.lightYellowColour, .orangeColour],startPoint: .top, endPoint: .bottom)
                            )
                            .cornerRadius(10)
                            .font(.system(size: 14, weight: .semibold))
                    }
                }
                .foregroundColor(.whiteColour)
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 15) {
                        ForEach(viewModel.languages, id: \.id) { language in
                            VStack(spacing: 3) {
                                Text(language.subTitle)
                                    .foregroundColor(.whiteColour)
                                
                                Text("(\(language.title))")
                                    .foregroundColor(viewModel.selectedLanguage?.id == language.id ? .whiteColour : .grayColour)
                                    .font(.system(size: 12))
                            }
                            .frame(maxWidth: .infinity, minHeight: 62)
                            .background (
                                LinearGradient( colors: [viewModel.selectedLanguage?.id == language.id ? .lightYellowColour : .lightBlackColour, viewModel.selectedLanguage?.id == language.id ? .orangeColour : .lightBlackColour],startPoint: .top, endPoint: .bottom)
                            )
                            .cornerRadius(10)
                            .onTapGesture {
                                viewModel.selectedLanguage = language
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
        }
        .defaultPage()
        .navigationDestination(isPresented: $viewModel.isOnBording) {
            OnBoding()
                .toolbar(.hidden, for: .navigationBar)
        }
        .onAppear {
            SwipeBackManager.shared.isEnabled = self.isShowBackButton
        }
    }
}

#Preview {
    LanguageScreen()
}
