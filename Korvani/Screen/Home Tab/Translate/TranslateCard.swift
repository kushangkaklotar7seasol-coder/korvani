//
//  TranslateCard.swift
//  CoreTools
//
//  Created by Vivek Rakholiya on 27/05/26.
//

import SwiftUI

struct LanguageSelectView: View {
    
    var title: String
    var languages: [TranslateLanguageModel]
    var onSelect: (TranslateLanguageModel) -> Void
    
    var body: some View {
        
        Menu {
            ForEach(languages, id: \.code) { language in
                Button {
                    onSelect(language)
                } label: {
                    Text(language.name)
                }
            }
            
        } label: {
            HStack(spacing: 8) {
                
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                
                Image(systemName: "chevron.down")
            }
            .frame(maxWidth: .infinity)
            .frame(height: 55)
        }
    }
}

struct TextCard: View {
    
    @Binding var text: String
    
    var languageName: String
    
    let pasteAction: () -> Void
    let volumeAction: () -> Void
    let copyAction: () -> Void
    let totalWord: String
    @FocusState var isTextFieldFocused: Bool
    
    var body: some View {
        
        ZStack {
            VStack() {
                HStack {
                    ZStack {
                        Text(Strings.sourceText)
                            .font(.system(size: 14, weight: .regular))
                            .foregroundStyle(.grayColour)
                    }
                    .cornerRadius(10)
                    
                    Spacer()
                    
//                    Button {
//                        pasteAction()
//                    } label: {
//                        
//                        ZStack {
//                            Text("Paste")
//                                .font(.system(size: 12, weight: .medium))
////                                .foregroundStyle(AppColor.textColor)
//                        }
//                        .padding(.horizontal, 10)
//                        .frame(height: 20)
//                        .background(Color("#EEEEEE"))
//                        .cornerRadius(10)
//                    }
//                    .buttonStyle(.plain)
                    
                    Button {
                        self.text = ""
                    } label: {
                        Image("ic_cancel")
                            .resizable()
                            .frame(width: 30, height: 30, alignment: .center)
                    }
                }
                
                // MARK: - TextEditor
                
                ZStack(alignment: .topLeading) {
                    if text.isEmpty {
                        Text(Strings.sourcePlaceholder)
                            .font(.system(size:16, weight: .regular))
                            .foregroundStyle(.grayColour)
                            .padding(.top, 5)
                    }
                    
                    TextEditor(text: $text)
                        .font(.system(size: 16))
                        .scrollContentBackground(.hidden)
                        .background(.clear)
                        .focused($isTextFieldFocused)
                        .frame(height: screenHeight/6)
                }
                
                HStack(spacing: 14) {
                    Spacer()
                    
                    Button {
                        volumeAction()
                    } label: {
                        Image("ic_volume")
                            .resizable()
                            .frame(width: 25, height: 25)
                    }
                    .buttonStyle(.plain)
                    
                    Button {
                        copyAction()
                    } label: {
                        Image("ic_copy")
                            .resizable()
                            .frame(width: 25, height: 25)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.lightBlackColour)
        .cornerRadius(16)
    }
}

struct resultCard: View {
    
    var languageName: String
    @Binding var translatedText: String
    
    let shareAction: () -> Void
    let volumeAction: () -> Void
    let copyAction: () -> Void
    @FocusState var isTextFieldFocused: Bool
    
    var body: some View {
        
        ZStack {
            VStack() {
                HStack {
                    Text(Strings.translate)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(.grayColour)
                    
                    Spacer()
                }
                
                ZStack(alignment: .topLeading) {
                    
                    if translatedText.isEmpty {
                        Text(Strings.translationPlaceholder)
                            .font(.system(size:16, weight: .regular))
                            .foregroundStyle(.grayColour)
                    }
                    
                    TextEditor(text: $translatedText)
                        .font(.system(size: 16))
                        .scrollContentBackground(.hidden)
                        .frame(height: screenHeight/6)
                        .focused($isTextFieldFocused)
                        .background(.clear)
                }
                
                HStack(spacing: 14) {
                    Spacer()
                    
                    Button {
                        volumeAction()
                    } label: {
                        Image("ic_volume")
                            .resizable()
                            .frame(width: 25, height: 25)
                    }
                    .buttonStyle(.plain)
                    
                    Button {
                        copyAction()
                    } label: {
                        Image("ic_copy")
                            .resizable()
                            .frame(width: 25, height: 25)
                    }
                    .buttonStyle(.plain)
                    
                    Button {
                        shareAction()
                    } label: {
                        Image("ic_share")
                            .resizable()
                            .frame(width: 25, height: 25)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding()
        .background(.lightBlackColour)
        .cornerRadius(16)
    }
}

#Preview {
//    LanguageSelectView(title: "", languages: [], onSelect: {_ in })
    
    TextCard(text: .constant("swefjlhweiorufhiowe"), languageName: "", pasteAction: {}, volumeAction: {}, copyAction: {}, totalWord: "0/500")
}
