//
//  SettingViewModel.swift
//  Korvani
//
//  Created by Kushang kaklotar on 20/07/26.
//

import Foundation
import Combine
import UIKit

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
        case 1:
            self.shareApp()
        case 2:
            self.rateApp()
        case 3:
            self.openURL(AppInfo.privacyPolicy)
        case 4:
            self.openURL(AppInfo.termsOfUse)
        default: break;
        }
    }
    
    // MARK: - Actions
//    func shareApp() {
//        let url = URL(string: AppInfo.shareApp)!
//        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
//        
//        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//           let root = scene.windows.first?.rootViewController {
//            root.present(activityVC, animated: true)
//        }
//    }
    
    func shareApp(from sourceView: UIView? = nil) {
        guard let url = URL(string: AppInfo.shareApp) else { return }
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        
        guard let scene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
              let rootVC = scene.windows.first(where: { $0.isKeyWindow })?.rootViewController else {
            return
        }
        
        if let popover = activityVC.popoverPresentationController {
            if let sourceView = sourceView {
                popover.sourceView = sourceView
                popover.sourceRect = sourceView.bounds
            } else {
                popover.sourceView = rootVC.view
                popover.sourceRect = CGRect(
                    x: rootVC.view.bounds.midX,
                    y: rootVC.view.bounds.midY,
                    width: 0,
                    height: 0
                )
                popover.permittedArrowDirections = []
            }
        }
        
        rootVC.present(activityVC, animated: true)
    }
    

    func rateApp() {
        guard let url = URL(string: AppInfo.rateApp) else { return }
        UIApplication.shared.open(url)
    }

    func openURL(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
    
}
