//
//  WallpaperExportViewModel.swift
//  Korvani
//
//  Created by Kushang kaklotar on 15/07/26.
//

import Foundation
import Combine
import Photos
import UIKit

class WallpaperExportViewModel: ObservableObject {
    var wallpaper: Wallpaper?
    @Published var downloadStatus = 0  // 0=Nothing, 1=Downloading, 2=SaveToPhotos
    @Published var showAlert = false
    @Published var showSettingsAlert = false
    
    init(wallpaper: Wallpaper? = nil) {
        self.wallpaper = wallpaper
    }
    
    func onExportImage(){
        DispatchQueue.main.async {
            self.downloadStatus = 1
        }
        WallpaperService.shared.downloadImage(url: URL(string: self.wallpaper?.src.original ?? "")!) { image in
            print(image)
            self.saveImageUsingPhotosFramework(image: image)
        } failure: { error in
            DispatchQueue.main.async {
                self.downloadStatus = 0
            }
            Toast.shared.show(message: error, type: .error)
        }
    }
    
    func saveImageUsingPhotosFramework(image: UIImage) {

        PHPhotoLibrary.requestAuthorization(for: .readWrite) { newStatus in
            DispatchQueue.main.async {
                switch newStatus {
                case .authorized, .limited:
                    
                    PHPhotoLibrary.shared().performChanges({
                        PHAssetChangeRequest.creationRequestForAsset(from: image)
                    }) { success, error in
                        if success {
                            print("Successfully saved to Photos library.")
                            
                            DispatchQueue.main.async {
                                self.downloadStatus = 2
                                self.showAlert = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                    self.downloadStatus = 0
                                }
                            }
                        } else if let error = error {
                            print("Failed to save image: \(error.localizedDescription)")
                            DispatchQueue.main.async {
                                self.downloadStatus = 0
                            }
                        }
                    }
                    
                case .denied, .restricted:
                    // 👇 User e deny karyu che, Settings navigate karva mate alert batavo
                    print("Permission denied")
                    self.downloadStatus = 0
                    self.showSettingsAlert = true   // 👈 alert trigger karo
                    
                case .notDetermined:
                    // Aa case actually requestAuthorization callback ma nai aave normally,
                    // pan safety mate rakhi lo
                    print("Permission not determined yet")
                    self.downloadStatus = 0
                    self.showSettingsAlert = true   // 👈 alert trigger karo
                    
                @unknown default:
                    self.downloadStatus = 0
                    self.showSettingsAlert = true 
                }
            }
        }
    }
    
    
    // 👇 Settings app open karva mate helper function
    func openAppSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
        }
    }
    
    
    func shareImage(){
        WallpaperService.shared.downloadImage(url: URL(string: self.wallpaper?.src.original ?? "")!) { image in
            let itemSource = ImageActivityItemSource(image: image, title: "")
            
            let controller = UIActivityViewController(
                activityItems: [itemSource],
                applicationActivities: nil
            )

            DispatchQueue.main.async {
            if let popover = controller.popoverPresentationController {
                if let topVC = UIApplication.shared.topViewController {
                    popover.sourceView = topVC.view
                    popover.sourceRect = CGRect(
                        x: topVC.view.bounds.midX,
                        y: topVC.view.bounds.midY,
                        width: 0,
                        height: 0
                    )
                    popover.permittedArrowDirections = []
                }
            }

            
                UIApplication.shared.topViewController?.present(controller, animated: true)
            }
            
        } failure: { error in
            print(error)
            Toast.shared.show(message: error, type: .error)
        }
    }
}

extension UIApplication {

    var topViewController: UIViewController? {
        guard let windowScene = connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene
                .windows
                .first(where: { $0.isKeyWindow })?
                .rootViewController else {
            return nil
        }

        return topViewController(from: rootViewController)
    }

    private func topViewController(from controller: UIViewController) -> UIViewController {

        if let navigationController = controller as? UINavigationController {
            return topViewController(from: navigationController.visibleViewController ?? navigationController)
        }

        if let tabBarController = controller as? UITabBarController {
            return topViewController(from: tabBarController.selectedViewController ?? tabBarController)
        }

        if let presented = controller.presentedViewController {
            return topViewController(from: presented)
        }

        return controller
    }
}

import UIKit
import LinkPresentation

class ImageActivityItemSource: NSObject, UIActivityItemSource {
    let image: UIImage
    let title: String
    
    init(image: UIImage, title: String = "Share Image") {
        self.image = image
        self.title = title
        super.init()
    }
    
    // ૧. શેર કરવા માટેનો આઈટમ ડેટા
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return image
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return image
    }
    
    // ૨. શેર શીટના Header Preview માં ઈમેજ બતાવવા માટે (Main Logic)
    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let metadata = LPLinkMetadata()
        metadata.title = title
        
        // ઈમેજના થંબનેલ (Thumbnail) તરીકે ઈમેજ પ્રોવાઈડ કરવી
        let itemProvider = NSItemProvider(object: image)
        metadata.imageProvider = itemProvider
        
        return metadata
    }
}
