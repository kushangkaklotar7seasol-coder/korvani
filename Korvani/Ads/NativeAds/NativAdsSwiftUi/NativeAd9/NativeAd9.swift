//
//  NativeAd9.swift
//  Screen Mirroring Casting
//
//  Created by Parthiv Akbari on 17/10/25.
//

import Foundation
//import ShimmerSwift
import SwiftUI

struct NativeAd9: View {
    @StateObject private var nativeViewModel = NativeAdViewModel()
//    @AppStorage(SessionKeys.isPro) var isPro = false
    @State var hasLoadedOnce = false
    
    var body: some View {
        VStack {
            if !isPro {
                if let _ = nativeViewModel.nativeAd {
                    NativeAd9Container(nativeViewModel: nativeViewModel)
                        .frame(height: Device.isIpad ? 168 : 140)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .transition(.opacity.combined(with: .scale))
                        .animation(.easeInOut(duration: 0.3), value: nativeViewModel.nativeAd)
                        .padding(.horizontal, 16)
//                        .modifier(GlassCardModifier(cornerRadius: 8))
                } else if nativeViewModel.didFailToLoad {
                    Color.clear
                        .frame(height: 0)
                        .animation(.easeOut(duration: 0.3), value: nativeViewModel.didFailToLoad)
                } else {
                    ZStack{
                        
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: Device.isIpad ? 168 : 140)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .shimmer()
                    .padding(.horizontal, 16)
                    
//                    ShimmerPlaceholderView()
//                        .frame(height: 140)
//                        .padding(.horizontal, 8)
//                        .transition(.opacity)
//                        .animation(.easeInOut(duration: 0.3), value: nativeViewModel.nativeAd)
                }
            }
        }
        .onAppear {
            if !hasLoadedOnce {
                nativeViewModel.refreshAd()
                hasLoadedOnce = true
            }
        }
    }
}

private struct NativeAd9Container: UIViewRepresentable {
    typealias UIViewType = GoogleNativeAdsCustomeView9
    
    @ObservedObject var nativeViewModel: NativeAdViewModel
    
    func makeUIView(context: Context) -> GoogleNativeAdsCustomeView9 {
        return GoogleNativeAdsCustomeView9.instanceFromNib() as! GoogleNativeAdsCustomeView9
    }
    
    func updateUIView(_ nativeAdView: GoogleNativeAdsCustomeView9, context: Context) {
        guard let nativeAd = nativeViewModel.nativeAd else { return }
        
        nativeAdView.nativeAd = nativeAd
        nativeAdView.setup()
    }
}

