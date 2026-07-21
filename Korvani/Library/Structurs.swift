//
//  Structurs.swift
//  Korvani
//
//  Created by Kushang kaklotar on 09/07/26.
//

import Foundation

struct OnBordingInfo {
    let id: Int
    var image: String
    var name: String
    var info: String
    var moreInfo: String? = nil
}

struct LanguageModel {
    let id: Int
    var name: String
    var language: String
}

struct SettingSection {
    let id: Int
    var name: String
    var items: [LanguageModel]
}

struct Puzzle: Codable {
    var id: Int
    var name: String
    var isUsed: Bool
}

struct LanguageItem: Identifiable, Codable {
    let id = UUID()
    let code: String

    var iconCode: String {
        switch code {
        case "en": return "EN"
        case "hi": return "HI"
        case "de": return "DE"
        case "pt-PT": return "PT"
        case "it": return "IT"
        case "es": return "ES"
        case "da": return "DA"
        case "tr": return "TR"
        case "fr": return "FR"
        case "ja": return "JA"
        case "nl": return "NL"
        case "ko": return "KO"
        case "zh-Hans": return "CH"
        case "ru": return "RU"
        default: return ""
        }
    }

    var subTitle: String {
        switch code {
        case "en": return "English"
        case "hi": return "Hindi"
        case "de": return "German"
        case "pt-PT": return "Portuguese"
        case "it": return "Italian"
        case "es": return "Spanish"
        case "da": return "Danish"
        case "tr": return "Turkish"
        case "fr": return "French"
        case "ja": return "Japanese"
        case "nl": return "Dutch"
        case "ko": return "Korean"
        case "zh-Hans": return "Chinese"
        case "ru": return "Russian"
        default: return ""
        }
    }

    var title: String {
        switch code {
        case "en": return "English"
        case "hi": return "हिंदी"
        case "de": return "Deutsch"
        case "pt-PT": return "Português"
        case "it": return "Italiano"
        case "es": return "Española"
        case "da": return "dansk"
        case "tr": return "Türkçe"
        case "fr": return "Français"
        case "ja": return "日本語"
        case "nl": return "Nederlands"
        case "ko": return "한국인"
        case "zh-Hans": return "中国人"
        case "ru": return "Русский"
        default: return ""
        }
    }
}
