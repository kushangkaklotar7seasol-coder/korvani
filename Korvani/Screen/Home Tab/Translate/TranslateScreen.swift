//
//  TranslateScreen.swift
//  Korvani
//
//  Created by Kushang kaklotar on 14/07/26.
//

import SwiftUI
internal import AVFAudio

struct TranslateScreen: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = TranslateViewModel()
    @State private var showShareSheet = false
    @FocusState private var isTextFieldFocused: Bool
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        ZStack {
            VStack {
                DefaultDesign.Header(name: Strings.translate, back: {
                    self.dismiss()
                })
                
                HStack {
                    Spacer()
                    LanguageSelectView(
                        title: viewModel.sourceLanguage.name,
                        languages: arrLanguage
                    ) { selectedLanguage in
                        let oldLanguage = viewModel.sourceLanguage
                        viewModel.sourceLanguage = selectedLanguage
                        if viewModel.sourceText == "" {
                            viewModel.translateText()
                        } else {
                            viewModel.translateOnSelect(isSourceText: true, onlLanguageCode: oldLanguage.code, newLanguageCode: viewModel.sourceLanguage.code)
                        }
                    }
                    Spacer()
                    Button {
                        viewModel.swapLanguages()
                        viewModel.translateText()
                    } label: {
                        Image("ic_swap_horizontal")
                            .resizable()
                            .frame(width: 38,height: 38)
                    }
                    .buttonStyle(.plain)
                    Spacer()
                    LanguageSelectView(
                        title: viewModel.targetLanguage.name,
                        languages: arrLanguage
                    ) { selectedLanguage in
                        let oldLanguage = viewModel.targetLanguage
                        viewModel.targetLanguage = selectedLanguage
//                        viewModel.translateText()
                        if viewModel.sourceText == "" {
                            viewModel.translateText()
                        } else {
                            viewModel.translateOnSelect(isSourceText: false, onlLanguageCode: oldLanguage.code, newLanguageCode: viewModel.targetLanguage.code)
                        }
                    }
                    Spacer()
                }
                .background(.lightBlackColour)
                .cornerRadius(16)
                .padding(.top, 10)
                
                ScrollView(.vertical,showsIndicators: false) {
                    TextCard(
                        text: $viewModel.sourceText,
                        languageName: viewModel.sourceLanguage.name,
                        pasteAction: {
                            if let pastedText = UIPasteboard.general.string {
                                viewModel.sourceText = pastedText
                                viewModel.translateText()
                            }
                        },
                        volumeAction: {
                            viewModel.speakText(
                                text: viewModel.sourceText,
                                languageCode: viewModel.sourceLanguage.code
                            )
                        },
                        copyAction: {
                            UIPasteboard.general.string = viewModel.sourceText
                            Toast.shared.show(message: "text copied", type: .success)
                        },
                        totalWord: "",
                        isTextFieldFocused: _isTextFieldFocused,
                    )
                    
                    resultCard(
                        languageName: viewModel.targetLanguage.name,
                        translatedText: $viewModel.translatedText,
                        shareAction: {
                            viewModel.shareText(viewModel.translatedText)
                        },
                        volumeAction: {
                            viewModel.speakText(
                                text: viewModel.translatedText,
                                languageCode: viewModel.targetLanguage.code
                            )
                        },
                        copyAction: {
                            UIPasteboard.general.string = viewModel.translatedText
                            Toast.shared.show(message: "text copied", type: .success)
                        },
                        isTextFieldFocused: _isTextFieldFocused,
                    )
                    .padding(.top, 10)
                }
                .padding(.top, 10)
                Spacer()
            }
        }
        .padding(.horizontal, 16)
        .defaultPage()
        .contentShape(Rectangle())
        .onTapGesture {
            isTextFieldFocused = false
        }
        .onChange(of: viewModel.sourceText) { _ in
            viewModel.translateText()
        }
        .onAppear {
            SwipeBackManager.shared.isEnabled = true
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            switch newPhase {
            case .background:
                if viewModel.isPlaying {
                    viewModel.speaker.pauseSpeaking(at: .immediate)
                }
            @unknown default:
                break
            }
        }
    }
}

#Preview {
    TranslateScreen()
}
