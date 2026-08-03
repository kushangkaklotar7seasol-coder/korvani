//
//  NativeAd6.swift
//  MovieBox
//
//  Created by Parthiv Akbari on 19/03/26.
//

import Foundation
import SwiftUI
import Combine

struct NativeAd6: View {
    @StateObject private var nativeViewModel = NativeAdViewModel()
//    @AppStorage(SessionKeys.isPro) var isPro = false
    @State var hasLoadedOnce = false

    var body: some View {
        VStack{
            if !isPro{
                if let _ = nativeViewModel.samllNativeAd {
                    NativeAd6Container(nativeViewModel: nativeViewModel)
                        .frame(height: Device.isIpad ? 100 : 82)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .transition(.opacity.combined(with: .scale))
                        .animation(.easeInOut(duration: 0.3), value: nativeViewModel.nativeAd)
                        .padding(.horizontal, 16)
                }else if nativeViewModel.didFailToLoadSmall {
                    Color.clear
                        .frame(height: 0)
                        .animation(.easeOut(duration: 0.3), value: nativeViewModel.didFailToLoadSmall)
                }  else {
                    ZStack{
                        
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: Device.isIpad ? 100 : 82)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .shimmer()
                    .padding(.horizontal, 16)
                }
            }
        }
            .onAppear {
                if !hasLoadedOnce {
                    nativeViewModel.refreshSamllAd()
                    hasLoadedOnce = true
                }
            }
    }
    
    private func refreshAd() {
        nativeViewModel.refreshSamllAd()
    }
}

private struct NativeAd6Container: UIViewRepresentable {
    typealias UIViewType = GoogleNativeAdsCustomeView6
    
    @ObservedObject var nativeViewModel: NativeAdViewModel
    
    func makeUIView(context: Context) -> GoogleNativeAdsCustomeView6 {
        return GoogleNativeAdsCustomeView6.instanceFromNib() as! GoogleNativeAdsCustomeView6
    }
    
    func updateUIView(_ nativeAdView: GoogleNativeAdsCustomeView6, context: Context) {
        guard let nativeAd = nativeViewModel.samllNativeAd else { return }
        
        nativeAdView.nativeAd = nativeAd
        nativeAdView.setup()
    }
}
