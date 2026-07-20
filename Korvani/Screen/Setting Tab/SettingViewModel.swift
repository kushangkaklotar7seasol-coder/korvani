//
//  SettingViewModel.swift
//  Korvani
//
//  Created by Kushang kaklotar on 20/07/26.
//

import Foundation
internal import Combine

class SettingViewModel: ObservableObject {
    @Published var isShowLanguage = false
    var settingItem: [SettingSection] = [SettingSection(id: 0, name: "Preferences",
                                                                   items: [LanguageModel(id: 0, name: "Language", language: "ic_global")]),
                                                    
                                                    SettingSection(id: 1, name: "Support & Information",
                                                                   items: [LanguageModel(id: 1, name: "Share App", language: "ic_share"),
                                                                           LanguageModel(id: 2, name: "Rate Us", language: "ic_star_white"),
                                                                           LanguageModel(id: 3, name: "Privacy Policy", language: "ic_lock"),
                                                                           LanguageModel(id: 4, name: "Terms of Use", language: "ic_terms")])]
    
    
    func onSelect(_ id: Int){
        switch id {
        case 0:
            self.isShowLanguage = true
        default: break;
        }
    }
}
