//
//  LaunchViewController.swift
//  Korvani
//
//  Created by Kushang kaklotar on 13/08/26.
//

import UIKit

class LaunchViewController: UIViewController {

    @IBOutlet weak var backgroundColourView: UIView!
    
    private let gradientLayer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradient()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = backgroundColourView.bounds
    }
    
    private func setupGradient() {
        gradientLayer.colors = [
            UIColor.pinkColour.cgColor,
            UIColor.cyanColour.cgColor,
            UIColor.lightSkyBlueColour.cgColor
        ]
        
        // topLeading -> bottomTrailing
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        
        backgroundColourView.layer.insertSublayer(gradientLayer, at: 0)
    }
}
