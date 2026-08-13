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
    @EnvironmentObject var adVm: AdCountViewModel
    
    let columns = Array(
        repeating: GridItem(.flexible(), spacing: 15),
        count: isiPad ? 3 : 2
    )
    
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
                    
                    Text(isiPad ? Strings.changeLanguageIpad : Strings.changeLanguage)
                        .font(.system(size: 20, weight: .semibold))
                    
                    Spacer()
                    
                    Button {
                        viewModel.onDoneButtonClick()
                        localization.changeLanguage(languageCode: viewModel.selectedLanguage?.code ?? "en")
                        if self.isShowBackButton {
                            self.dismiss()
                            adVm.registerTap()
                            logAnalyticAction(title: "", status: AnalyticEvent.languageScreen)
                        } else {
                            viewModel.isOnBording = true
                        }
                    } label: {
                        Text(Strings.done)
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
                .padding(.horizontal, 16)
                
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: columns, spacing: 15) {
                        ForEach(viewModel.languages, id: \.id) { language in
                            VStack(spacing: 3) {
                                Text(language.subTitle)
                                    .foregroundColor(.whiteColour)
                                
                                Text("(\(language.title))")
                                    .foregroundColor(viewModel.selectedLanguage?.code == language.code ? .whiteColour : .grayColour)
                                    .font(.system(size: 12))
                            }
                            .frame(maxWidth: .infinity, minHeight: isiPad ?  92 : 62)
                            .background (
                                LinearGradient( colors: [viewModel.selectedLanguage?.code == language.code ? .lightYellowColour : .lightBlackColour, viewModel.selectedLanguage?.code == language.code ? .orangeColour : .lightBlackColour],startPoint: .top, endPoint: .bottom)
                            )
                            .cornerRadius(10)
                            .onTapGesture {
                                viewModel.selectedLanguage = language
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    

                }
                
                Spacer()
                
                if isShowAdd() {
                    NativeAd9()
                }
            }
            
        }
        .defaultPage()
        .navigationDestination(isPresented: $viewModel.isOnBording) {
            OnBoding()
                .toolbar(.hidden, for: .navigationBar)
        }
        .onAppear {
            SwipeBackManager.shared.isEnabled = self.isShowBackButton
            viewModel.selectedLanguage = UserdefaultManager.shared.getLanguage() ?? LanguageItem(code: "en")
        }
    }
}

#Preview {
    LanguageScreen()
}
