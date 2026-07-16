//
//  SplashViewModel.swift
//  Korvani
//
//  Created by Kushang kaklotar on 09/07/26.
//

import Foundation
internal import Combine
import SwiftUI

class SplashViewModel: ObservableObject {
    @Published var navigation = (OnBoding: false, home: false, language: false)
    
    init() {
        self.navigationManager()
    }
    
    func navigationManager(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
             let language = UserdefaultManager.shared.getLanguage()
             let onBoarding = UserdefaultManager.shared.getOnBoarding()
            
            if language == nil {
                self.navigation.language = true
                return
            }
            
            if onBoarding == 0 {
                self.navigation.home = true
                return
            }
            
            self.navigation.OnBoding = true
        }
    }
}
