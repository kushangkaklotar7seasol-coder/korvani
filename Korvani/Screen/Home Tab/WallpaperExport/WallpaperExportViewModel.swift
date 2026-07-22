//
//  WallpaperExportViewModel.swift
//  Korvani
//
//  Created by Kushang kaklotar on 15/07/26.
//

import Foundation
internal import Combine
import Photos
import UIKit

class WallpaperExportViewModel: ObservableObject {
    var wallpaper: Wallpaper?
    @Published var downloadStatus = 0  // 0=Nothing, 1=Downloading, 2=SaveToPhotos
    
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
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }) { success, error in
            if success {
                print("Successfully saved to Photos library.")
                
                DispatchQueue.main.async {
                    self.downloadStatus = 2
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
    }
    
    func shareImage(){
        WallpaperService.shared.downloadImage(url: URL(string: self.wallpaper?.src.original ?? "")!) { image in
            
            let controller = UIActivityViewController(
                activityItems: [image],
                applicationActivities: nil
            )
            
            DispatchQueue.main.async {
                UIApplication.shared.topViewController?
                    .present(controller, animated: true)
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
