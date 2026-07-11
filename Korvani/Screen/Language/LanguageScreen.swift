//
//  LanguageScreen.swift
//  Korvani
//
//  Created by Kushang kaklotar on 10/07/26.
//

import SwiftUI

struct LanguageScreen: View {
    @StateObject var viewModel = LanguageViewModel()
    
    let columns = [
        GridItem(.flexible(), spacing: 15),
        GridItem(.flexible(), spacing: 15)
    ]
    
    var body: some View {
        ZStack {
            VStack {
                
                HStack {
                    Text("Choose Your\nPreferred Language")
                        .font(.system(size: 20, weight: .semibold))
                    
                    Spacer()
                    
                    Button {
                        viewModel.onDoneButtonClick()
                        viewModel.isOnBording = true
                    } label: {
                        Text("Done")
                            .padding()
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
        .background(.blackColour)
        .navigationDestination(isPresented: $viewModel.isOnBording) {
            OnBoding()
                .toolbar(.hidden, for: .navigationBar)
        }
    }
}

#Preview {
    LanguageScreen()
}
