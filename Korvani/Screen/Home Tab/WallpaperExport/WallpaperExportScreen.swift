//
//  WallpaperExportScreen.swift
//  Korvani
//
//  Created by Kushang kaklotar on 15/07/26.
//

import SwiftUI
import Kingfisher

struct WallpaperExportScreen: View {
    @StateObject var viewModel: WallpaperExportViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var refreshID = UUID()
    
    var imagewidth: CGFloat {
        return screenWidth-48
    }
    
    var imageHeight: CGFloat {
        if isiPad {
            if Device.isiPadLandscape {
                if isShowAdd() {
                    return screenHeight-300
                } else {
                    return screenHeight-200
                }
            } else {
                if Device.isIpad {
                    return screenHeight-300
                } else {
                    return screenHeight-200
                }
            }
        } else {
            return .infinity
        }
    }
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button {
                        self.dismiss()
                    } label: {
                        Image("ic_back")
                            .resizable()
                            .frame(width: 40, height: 40, alignment: .center)
                    }
                    .frame(width: 50, height: 50, alignment: .center)
                    .contentShape(Rectangle())
//                    .background(.red)
                    
                    Spacer()
                    
                    Button {
                        viewModel.shareImage()
                    } label: {
                        Image("ic_share_background")
                            .resizable()
                            .frame(width: 40, height: 40, alignment: .center)
                    }
                }
                .padding(.horizontal, 20)
                .zIndex(1)
                
                Spacer()
                
                ZStack {
                    KFImage.url(URL(string: isiPad ? viewModel.wallpaper?.src.large ?? "" : viewModel.wallpaper?.src.medium ?? ""))
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: imagewidth, maxHeight: imageHeight)
                        .clipped()
                }
                .allowsHitTesting(false)
                .id(refreshID)
                .frame(maxWidth: imagewidth, maxHeight: imageHeight)
                .background(.grayColour.opacity(0.5))
                .cornerRadius(16)
                .padding(.top, 24)
                .padding(.horizontal, 20)
                
                if isShowAdd() {
                    NativeAd6()
                }
                
                Button {
                    viewModel.onExportImage()
                } label: {
                    Text(Strings.export)
                        .padding()
                        .frame(maxWidth: Device.isiPadLandscape ?  imagewidth : .infinity)
                        .font(.system(size: 18, weight: .semibold))
                        .background(
                            LinearGradient(colors: [.lightYellowColour,.orangeColour], startPoint: .top, endPoint: .bottom))
                        .cornerRadius(10)
                }
                .padding(.top, 5)
                .padding(.bottom, 2)
                .padding(.horizontal, 20)
                .id(refreshID)
            }
        }
        .defaultPage()
        .background(.red)
        .alert(Strings.downloadSuccess, isPresented: $viewModel.showAlert) {
            Button(Strings.ok) { }
        } message: {
            Text(Strings.checkPhotosApp)
        }
        .alert(Strings.permissionAccess, isPresented: $viewModel.showSettingsAlert) {
            Button(Strings.cancel, role: .cancel) { }
            Button(Strings.openSetting) {
                viewModel.openAppSettings()
            }
        } message: {
            Text(Strings.photoDownloadAllow)
        }
        .onReceive(
            NotificationCenter.default.publisher(
                for: UIDevice.orientationDidChangeNotification
            )
        ) { _ in
            refreshID = UUID()
        }
    }
}

#Preview {
    WallpaperExportScreen(viewModel: WallpaperExportViewModel())
}
