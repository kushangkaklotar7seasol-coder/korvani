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
        self.savePuzzle()
    }
    
    func navigationManager(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
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
    
    func savePuzzle(){
        if UserdefaultManager.shared.getPuzzle().isEmpty {
            let puzzleQuiz: [Puzzle] = [Puzzle(id: 0, name: "puzzle_1", isUsed: false),
                                        Puzzle(id: 1, name: "puzzle_2", isUsed: false),
                                        Puzzle(id: 2, name: "puzzle_3", isUsed: false),
                                        Puzzle(id: 3, name: "puzzle_4", isUsed: false),
                                        Puzzle(id: 4, name: "puzzle_5", isUsed: false),
                                        Puzzle(id: 5, name: "puzzle_6", isUsed: false),
                                        Puzzle(id: 6, name: "puzzle_7", isUsed: false),
                                        Puzzle(id: 7, name: "puzzle_8", isUsed: false),
                                        Puzzle(id: 8, name: "puzzle_9", isUsed: false),
                                        Puzzle(id: 9, name: "puzzle_10", isUsed: false),
                                        Puzzle(id: 10, name: "puzzle_11", isUsed: false),
                                        Puzzle(id: 11, name: "puzzle_12", isUsed: false)]
            
            UserdefaultManager.shared.savePuzzle(puzzleQuiz)
        }
    }
}
