//
//  View+Extension.swift
//  Korvani
//
//  Created by Kushang kaklotar on 11/07/26.
//

import Foundation
import SwiftUI

extension View {
    func defaultPage() -> some View {
        self
            .navigationBarHidden(true)
            .background(.blackColour)
            .foregroundColor(.whiteColour)
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
