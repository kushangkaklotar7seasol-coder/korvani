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
                    return screenHeight-350
                } else {
                    return screenHeight-200
                }
            } else {
                if Device.isIpad {
                    return screenHeight-350
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
                DefaultDesign.Header(isShowSecondbutton: true, back: {
                    self.dismiss()
                }, secondButton: {
                    viewModel.shareImage()
                })
                .padding(.horizontal, 20)
                
                ZStack {
                    KFImage.url(URL(string: isiPad ? viewModel.wallpaper?.src.large2x ?? "" : viewModel.wallpaper?.src.medium ?? ""))
                        .resizable()
                        .scaledToFill()
                        .clipped()
                }
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
            }
            
//            VStack {
//                if viewModel.downloadStatus == 1 {
//                    Text(Strings.downloading)
//                        .padding()
//                        .font(.system(size: 18, weight: .bold))
//                        .background(.blackColour.opacity(0.5))
//                        .cornerRadius(10)
//                        .transition(.asymmetric(
//                                        insertion: .scale(scale: 0.7).combined(with: .opacity),
//                                        removal: .opacity
//                                    ))
//                }
                
//                if viewModel.downloadStatus == 2 {
//                    VStack(spacing: 0) {
//                        Text(Strings.downloadSuccess)
//                            .font(.system(size: 18, weight: .bold))
//                        
//                        Text(Strings.checkPhotosApp)
//                    }
//                    .padding()
//                    .background(.greenColour.opacity(0.7))
//                    .cornerRadius(10)
//                    .transition(.asymmetric(
//                                insertion: .scale(scale: 0.7).combined(with: .opacity),
//                                removal: .move(edge: .top).combined(with: .opacity)
//                            ))
//                }
//            }
//            .animation(.spring(response: 0.4, dampingFraction: 0.7), value: viewModel.downloadStatus)
        }
        .defaultPage()
        .id(refreshID)
        .onAppear() {
            SwipeBackManager.shared.isEnabled = true
        }
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
