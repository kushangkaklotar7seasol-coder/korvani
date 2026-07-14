//
//  TranslateViewModel.swift
//  Korvani
//
//  Created by Kushang kaklotar on 14/07/26.
//

import Foundation
internal import Combine
import AVFAudio
import UIKit

struct TranslateLanguageModel {
    var name: String
    var code: String
    var lan: String
}
//
var arrLanguage: [TranslateLanguageModel] = [
    .init(name: "English",   code: "en", lan: "English"),
    .init(name: "Hindi",     code: "hi", lan: "हिन्दी"),
    .init(name: "German",    code: "de", lan: "Deutsch"),
    .init(name: "Portuguese", code: "pt-PT", lan: "Português"),
    .init(name: "Italian",   code: "it", lan: "Italiano"),
    .init(name: "Spanish",   code: "es", lan: "Español"),
    .init(name: "Danish",    code: "da", lan: "dansk"),
    .init(name: "Turkish",   code: "tr", lan: "Türkçe"),
    .init(name: "Chinese",   code: "zh-Hant", lan: "繁體中文"),
    .init(name: "Russian",   code: "ru", lan: "Русский"),
    .init(name: "Japanese",  code: "ja", lan: "日本語"),
    .init(name: "Dutch",     code: "nl", lan: "Nederlands"),
    .init(name: "Korean",    code: "ko", lan: "한국인"),
    .init(name: "French",    code: "fr", lan: "Français"),
]


class TranslateViewModel: ObservableObject {
    
    
    @Published var sourceLanguage: TranslateLanguageModel = arrLanguage[0]
    @Published var targetLanguage: TranslateLanguageModel = arrLanguage[1]
    
    @Published var sourceText: String = ""
    @Published var translatedText: String = ""
    @Published private var speaker = AVSpeechSynthesizer()
    
    
    func swapLanguages() {

        // Language Swap
        let tempLanguage = sourceLanguage
        sourceLanguage = targetLanguage
        targetLanguage = tempLanguage

        // Text Swap
        let tempText = sourceText
        sourceText = translatedText
        translatedText = tempText
    }
    
    func translateText() {
        
        guard !sourceText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            translatedText = ""
            return
        }
        
        callTranslateAPI(
            strValue: sourceText,
            sourceLanguageCode: sourceLanguage.code,
            targetLanguageCode: targetLanguage.code
        ) { error, success, translatedValue in
            
            if success {
                self.translatedText = translatedValue ?? ""
            }
        }
    }
    
    func callTranslateAPI(
        strValue: String,
        sourceLanguageCode: String,
        targetLanguageCode: String,
        completion: @escaping ((Error?, Bool, String?) -> Void)
    ) {
        
        var components = URLComponents(string: translateAPI)!
        
        components.queryItems = [
            URLQueryItem(name: "client", value: "gtx"),
            URLQueryItem(name: "sl", value: sourceLanguageCode),
            URLQueryItem(name: "tl", value: targetLanguageCode),
            URLQueryItem(name: "dt", value: "t"),
            URLQueryItem(name: "q", value: strValue)
        ]
        
        guard let url = components.url else {
            completion(NSError(domain: "InvalidURL", code: 0), false, nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                DispatchQueue.main.async {
                    completion(error, false, nil)
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(NSError(domain: "NoData", code: 0), false, nil)
                }
                return
            }
            
            do {
                
                if let json = try JSONSerialization.jsonObject(with: data) as? NSArray,
                   let first = json[0] as? NSArray {
                    
                    var translatedText = ""
                    
                    for item in first {
                        if let arr = item as? NSArray,
                           let text = arr[0] as? String {
                            translatedText.append(text)
                        }
                    }
                    
                    DispatchQueue.main.async {
                        completion(nil, true, translatedText)
                    }
                    
                } else {
                    DispatchQueue.main.async {
                        completion(NSError(domain: "ParsingError", code: 0), false, nil)
                    }
                }
                
            } catch {
                DispatchQueue.main.async {
                    completion(error, false, nil)
                }
            }
        }
        
        task.resume()
    }
    
    func speakText(text: String, languageCode: String) {
        
        guard !text.isEmpty else { return }
        
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: languageCode)
        
        speaker.stopSpeaking(at: .immediate)
        speaker.speak(utterance)
    }
    
    func shareText(_ text: String) {
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            return
        }
        
        let activityVC = UIActivityViewController(
            activityItems: [text],
            applicationActivities: nil
        )
        
        rootViewController.present(activityVC, animated: true)
    }
}
