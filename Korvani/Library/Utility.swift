//
//  Utility.swift
//  Korvani
//
//  Created by Kushang kaklotar on 11/07/26.
//

import Foundation
import UIKit

class Utility {
    static let shared = Utility()
    
    // MARK: - Internet -
    class func isInternetAvailable() -> Bool{
        var  isAvailable : Bool
        isAvailable = true
        let reachability = try? Reachability() //try? Reachability(hostname: "google.com") //Reachability()
        if(reachability?.connection == Reachability.Connection.unavailable)
        {
            isAvailable = false
        }
        else
        {
            isAvailable = true
        }
        
        return isAvailable
    }

    class func getWeatherImageUrl(_ code: String) -> String {
        return "https://openweathermap.org/img/wn/\(code)@2x.png"
    }
    
    class func closeKeyboard(){
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

