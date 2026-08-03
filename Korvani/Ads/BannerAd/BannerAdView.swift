//
//  BannerAdView.swift
//  Screen Mirroring Casting
//
//  Created by Parthiv Akbari on 18/05/26.
//

import SwiftUI
import GoogleMobileAds

struct BannerAdView: UIViewRepresentable {
    
    let bannerView: BannerView
    
    func makeUIView(context: Context) -> UIView {
        
        let view = UIView(frame: .zero)
        
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(bannerView)
        
        NSLayoutConstraint.activate([
            bannerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bannerView.topAnchor.constraint(equalTo: view.topAnchor),
            bannerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}
