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
    
//    class func shareText(_ text: String) {
//        
//        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//              let rootViewController = windowScene.windows.first?.rootViewController else {
//            return
//        }
//        
//        let activityVC = UIActivityViewController(
//            activityItems: [text],
//            applicationActivities: nil
//        )
//        
//        rootViewController.present(activityVC, animated: true)
//    }
    
    class func shareText(_ text: String, url: String? = nil, image: UIImage? = nil, from sourceView: UIView? = nil) {
        var itemsToShare: [Any] = [text]
        
        if let urlString = url, let shareURL = URL(string: urlString) {
            itemsToShare.append(shareURL)
        }
        
        if let shareImage = image {
            itemsToShare.append(shareImage)
        }
        
        let activityVC = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
        
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
}

