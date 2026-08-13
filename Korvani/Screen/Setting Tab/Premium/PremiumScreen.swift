//
//  PremiumScreen.swift
//  Korvani
//
//  Created by Kushang kaklotar on 12/08/26.
//

import SwiftUI

struct PremiumScreen: View {
    @StateObject private var viewModel = PremiumViewModel()
    @StateObject private var interstitialAdsManager = InterstitialAdManager()
    @EnvironmentObject var addViewModel: AdCountViewModel
    @Environment(\.dismiss) private var dismiss
    
    var isFromIntro: Bool = false
    var onDismiss: (() -> Void)?
    
    private let primaryOrange: Color = .orangeColour
    private let cardBackground: Color = .tabbarBackgroundColour
    private let cardBorder: Color = .borderColour
    private let textSecondary: Color = .grayColour
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    
                    ZStack {
                        ZStack(alignment: .bottom) {
                            Image("img_premium")
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity)
                                .frame(height: screenHeight/2.5)
                                .clipped()
                            
                            VStack(spacing: 8) {
                                ZStack {
                                    Image("ic_premium")
                                        .resizable()
                                        .frame(width: 46, height: 46, alignment: .center)
                                }
                                .frame(width: 80, height: 80, alignment: .center)
                                .background(
                                    LinearGradient(colors: [.lightYellowColour, .orangeColour], startPoint: .top, endPoint: .bottom)
                                )
                                .cornerRadius(48)
                                .shadow(color: .orangeColour, radius: 20, x: 0.5, y: 0.5)
                                
                                Text("Unlock Premium")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.white)
                                
                                Text("Get unlimited access to all premium\nfeatures.")
                                    .font(.system(size: 14))
                                    .foregroundColor(textSecondary)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.horizontal, 16)
                        }
                    }
                    // MARK: - Feature List
                    VStack(alignment: .leading, spacing: 12) {
                        featureRow(title: "Ad-free experience")
                        featureRow(title: "Instant where to watch details")
                        if isYoutubeEnabled {
                            featureRow(title: "Watch unlimited HD trailers")
                        }
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 24)
                    
                    // MARK: - Subscription Plans
                    VStack(spacing: 12) {
                        ForEach(Array(viewModel.sortedPlansByPrice.enumerated()), id: \.element) { index, plan in
                            let product = viewModel.product(for: plan)
                            let isSelected = viewModel.selectedPlan == plan
                            
                            // StoreKit માથી જેની કિંમત સૌથી વધારે હશે એના પર જ Best Value બતાવશે
                            let isHighestValue = plan == viewModel.highestValuePlan
                            
                            planCard(
                                title: plan.title,
                                price: viewModel.priceText(for: product),
                                period: plan.period,
                                isSelected: isSelected,
                                isBestValue: hasMultiplePlans && isHighestValue
                            ) {
                                viewModel.selectPlan(plan)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    
                    // MARK: - Continue / Action Button
                    Button {
                        viewModel.makePurchase()
                    } label: {
                        HStack(spacing: 8) {
                            if viewModel.isLoading {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text("Continue")
                                    .foregroundColor(.white)
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            LinearGradient(
                                colors: [.lightYellowColour, .orangeColour],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .cornerRadius(14)
                    }
                    .buttonStyle(.plain)
                    .disabled(viewModel.isLoading)
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    
                    // MARK: - Footer Links
                    footerLinks
                        .padding(.top, 4)
                        .padding(.horizontal, 16)
                    
                    // MARK: - Legal / Subscription Info
                    subscriptionInfoView
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                }
                .padding(.bottom, 30)
            }
            .scrollBounceBehavior(.basedOnSize)
            .edgesIgnoringSafeArea(.top)
            
            // MARK: - Close Button Overlay
            HStack {
                Button {
                    dismiss()
                    onDismiss?()
                } label: {
                    Image("ic_cancel") // Uses your close button asset
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(.whiteColour)
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                        .padding(7)
                        .background(.whiteColour.opacity(0.2))
                        .cornerRadius(32)
                        .overlay {
                            RoundedRectangle(cornerRadius: 32)
                                .strokeBorder(.whiteColour.opacity(0.5))
                        }
                }
                
                Spacer()
                
                Button {
                    viewModel.restore()
                } label: {
                    Text("Restore")
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .font(.system(size: 14, weight: .medium))
                        .background(.whiteColour.opacity(0.2))
                        .cornerRadius(8)
                        .overlay {
                            RoundedRectangle(cornerRadius: 8)
                                .strokeBorder(.whiteColour.opacity(0.5))
                        }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
        }
        .defaultPage()
        .onAppear {
//            TabBarState.shared.isHidden = true
            sholdShowAppOpenAd = false
            interstitialAdsManager.load()
            
            viewModel.onPurchaseSuccess = {
                dismiss()
                onDismiss?()
            }
            viewModel.onRestoreSuccess = {
                // Handle restore if needed
            }
        }
        .onDisappear {
            sholdShowAppOpenAd = true
        }
        .task {
//            logAnalyticAction(title: "", status: AnalyticEvent.Premium)
            viewModel.fetchInAppProduct()
        }
        .alert(viewModel.alertMessage, isPresented: $viewModel.showAlert) {
            Button("Ok", role: .cancel) { }
        }
    }
}

// MARK: - Supporting Subviews & Components
private extension PremiumScreen {
    
    // Feature Row View
    func featureRow(title: String) -> some View {
        HStack(spacing: 12) {
            Image("ic_right_orange")
                .font(.system(size: 18))
                .foregroundColor(primaryOrange)
            
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white)
            
            Spacer()
        }
    }
    
    // Plan Selection Card Component
    func planCard(
        title: String,
        price: String,
        period: String,
        isSelected: Bool,
        isBestValue: Bool = false,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            ZStack(alignment: .topTrailing) {
                HStack(spacing: 16) {
                    // Radio Button
                    Image(isSelected ? "ic_circle_selected" : "ic_circle")
                        .font(.system(size: 20))
                        .foregroundColor(isSelected ? primaryOrange : textSecondary)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(title)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.whiteColour)
                        
                        Text("\(price) / \(period)")
                            .font(.system(size: 14))
                            .foregroundColor(textSecondary)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
                .frame(height: 64)
                .background(
                    LinearGradient(colors: [isSelected ? .lightYellowColour.opacity(0.1) : .borderColour.opacity(0.5),
                                            isSelected ? .orangeColour.opacity(0.1) : .borderColour.opacity(0.5)],
                                           startPoint: .top, endPoint: .bottom)
                )
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(LinearGradient(colors: [isSelected ? .lightYellowColour : .borderColour,
                                                        isSelected ? .orangeColour : .borderColour],
                                               startPoint: .top, endPoint: .bottom), lineWidth: 1.5)
                )
                
                // "Best Value" Badge
                if isBestValue {
                    Text("Best Value")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.whiteColour)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(
                            LinearGradient(colors: [.lightYellowColour, .orangeColour], startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                        .clipShape(CornerRadiusShape(radius: 10, corners: [.topRight, .bottomLeft]))
                }
            }
        }
        .buttonStyle(.plain)
    }
    
    // Footer Link Row
    var footerLinks: some View {
        HStack(spacing: 16) {
            footerButton("Terms of use")
            footerDivider
            footerButton("Privacy policy")
            footerDivider
            footerButton("Eula")
        }
    }
    
    var footerDivider: some View {
        Rectangle()
            .fill(Color.white.opacity(0.2))
            .frame(width: 1, height: 12)
    }
    
    func footerButton(_ title: String) -> some View {
        Button {
            if title == "Privacy policy" {
                viewModel.openURL(AppInfo.privacyPolicy)
            } else if title == "Terms of use" {
                viewModel.openURL(AppInfo.termsOfUse)
            } else if title == "Eula" {
                viewModel.openURL(AppInfo.eula)
            }
        } label: {
            Text(title)
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(textSecondary)
        }
        .buttonStyle(.plain)
    }
    
    // Subscription Disclaimers
    var subscriptionInfoView: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Pre-Paid Plan")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)
            
            Text("Subscription options are available only through the App Store. Payment will be charged to your Apple ID account once your subscription starts. Subscriptions renew automatically at the same price and duration unless canceled at least 24 hours before the current period ends. You can manage or cancel your subscription anytime in your Apple ID account settings. By subscribing, you agree to our Privacy Policy and Terms.")
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(textSecondary)
                .multilineTextAlignment(.leading)
                .padding(.bottom, 6)
            
            Text("How to manage my subscription?")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)
            
            Text("1. Open the Settings app on your device.\n2. Tap your name at the top.\n3. Tap Subscriptions.\n4. Tap the subscription that you want to manage.")
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(textSecondary)
                .multilineTextAlignment(.leading)
        }
    }
}

// Helper Shape for specific corner rounding
struct CornerRadiusShape: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    PremiumScreen()
        .environmentObject(AdCountViewModel())
}
