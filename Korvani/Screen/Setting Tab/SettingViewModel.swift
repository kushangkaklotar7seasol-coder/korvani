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
    var settingItem: [SettingSection] = [SettingSection(id: 0, name: "PREFERENCES",
                                                                   items: [LanguageModel(id: 0, name: "LANGUAGE", language: "ic_global")]),
                                                    
                                                    SettingSection(id: 1, name: "SUPPORT_INFO",
                                                                   items: [LanguageModel(id: 1, name: "SHARE_APP", language: "ic_share_white"),
                                                                           LanguageModel(id: 2, name: "RATE_US", language: "ic_star_white"),
                                                                           LanguageModel(id: 3, name: "PRIVECY_POLICY", language: "ic_lock"),
                                                                           LanguageModel(id: 4, name: "TEMS_USE", language: "ic_terms")])]
    
    
    func onSelect(_ id: Int){
        switch id {
        case 0:
            self.isShowLanguage = true
        default: break;
        }
    }
}
