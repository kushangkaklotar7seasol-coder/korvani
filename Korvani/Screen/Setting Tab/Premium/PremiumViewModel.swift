//
//  PremiumViewModel.swift
//  Korvani
//
//  Created by Kushang kaklotar on 12/08/26.
//

import Foundation
import SwiftUI
import Combine
import StoreKit

enum PremiumPlan: String, CaseIterable {
    case lifetime
    case yearly
    case monthly
    case weekly
    
    static var enabledPlans: [PremiumPlan] {
        var plans: [PremiumPlan] = []
        
        if isShowLifetime { plans.append(.lifetime) }
        if isShowYearlyPlan { plans.append(.yearly) }
        if isShowMonthlyPlan { plans.append(.monthly) }
        if isShowWeeklyPlan { plans.append(.weekly) }
        
        return plans
    }
    
    var title: String {
        switch self {
        case .lifetime: return "Life Time"
        case .yearly: return "Year"
        case .monthly: return "Month"
        case .weekly: return "Week"
        }
    }
    
    var subtitle: String {
        switch self {
        case .lifetime: return ""
        case .yearly: return "Best value"
        case .monthly: return "Flexible billing"
        case .weekly: return "Try weekly Access"
        }
    }
    
    var period: String {
        switch self {
        case .lifetime: return "one time"
        case .yearly: return "per year"
        case .monthly: return "per month"
        case .weekly: return "per week"
        }
    }
    
    var productID: String {
        switch self {
        case .lifetime: return Products.lifetime.rawValue
        case .yearly: return Products.yearly.rawValue
        case .monthly: return Products.monthly.rawValue
        case .weekly: return Products.weekly.rawValue
        }
    }
}


class PremiumViewModel: NSObject, ObservableObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    @Published var selectedPlan: PremiumPlan = PremiumPlan.enabledPlans.first ?? .lifetime
    @Published var products: [SKProduct] = []
    @Published var selectedProduct: SKProduct?
    
    @Published var isRestoring = false
    @Published var isLoading = false
    @Published var alertMessage = ""
    @Published var showAlert = false
    
    var onPurchaseSuccess: (() -> Void)?
    var onRestoreSuccess: (() -> Void)?
    
    override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }
    
    deinit {
        SKPaymentQueue.default().remove(self)
    }
    
    func fetchInAppProduct() {
        isLoading = true
        
        let identifiers = Set(
            PremiumPlan.enabledPlans.map { $0.productID }
        )
        
        let request = SKProductsRequest(productIdentifiers: identifiers)
        request.delegate = self
        request.start()
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        DispatchQueue.main.async {
            self.products = response.products.sorted { product1, product2 in
                self.sortIndex(product1.productIdentifier) < self.sortIndex(product2.productIdentifier)
            }
            
            if let firstPlan = PremiumPlan.enabledPlans.first {
                self.selectPlan(firstPlan)
            }
            
            self.isLoading = false
            
            if self.products.isEmpty {
                self.showAlertMsg(message: "Products not found.")
            }
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.isLoading = false
            self.showAlertMsg(message: error.localizedDescription)
        }
    }
    
    func selectPlan(_ plan: PremiumPlan) {
        selectedPlan = plan
        selectedProduct = products.first { $0.productIdentifier == plan.productID }
    }
    
    func product(for plan: PremiumPlan) -> SKProduct? {
        products.first { $0.productIdentifier == plan.productID }
    }
    
    var highestValuePlan: PremiumPlan? {
            PremiumPlan.enabledPlans.max { plan1, plan2 in
                let price1 = product(for: plan1)?.price ?? 0
                let price2 = product(for: plan2)?.price ?? 0
                return price1.compare(price2) == .orderedAscending
            }
        }
    
    var sortedPlansByPrice: [PremiumPlan] {
        return PremiumPlan.enabledPlans.sorted { plan1, plan2 in
            let price1 = product(for: plan1)?.price ?? 0
            let price2 = product(for: plan2)?.price ?? 0
            return price1.compare(price2) == .orderedDescending
        }
    }
    
    func priceText(for product: SKProduct?) -> String {
        guard let product else { return "--" }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = product.priceLocale
        
        return formatter.string(from: product.price) ?? "\(product.price)"
    }
    
    func makePurchase() {
        guard let product = selectedProduct else {
            showAlertMsg(message: "Product not available.")
            return
        }
        
        guard SKPaymentQueue.canMakePayments() else {
            showAlertMsg(message: "In-App Purchases are disabled on this device.")
            return
        }
        
        isLoading = true
        SKPaymentQueue.default().add(SKPayment(product: product))
    }
    
    func restore() {
        isLoading = true
        isRestoring = true
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        DispatchQueue.main.async {
            for transaction in transactions {
                switch transaction.transactionState {
                case .purchased:
                    queue.finishTransaction(transaction)
                    isPro = true
                    UserdefaultManager.shared.savePro(true)
                    self.isLoading = false
                    self.onPurchaseSuccess?()
                    NotificationCenter.default.post(name: .addRemoveFromDiscover, object: nil)
                    
                case .restored:
                    queue.finishTransaction(transaction)
                    UserdefaultManager.shared.savePro(true)
                    isPro = true
                    self.isLoading = false
                    self.isRestoring = false
                    self.showAlertMsg(message: "Your premium access has been successfully restored!")
                    self.onRestoreSuccess?()
                    NotificationCenter.default.post(name: .addRemoveFromDiscover, object: nil)
                    
                case .failed:
                    queue.finishTransaction(transaction)
                    self.isLoading = false
                    self.isRestoring = false
                    
                    if let error = transaction.error as? SKError,
                       error.code == .paymentCancelled {
                        self.showAlertMsg(message: "Either you cancelled the request or Apple reported a transaction error. Please try again later, or contact the app's customer support for assistance.")
                    } else {
                        self.showAlertMsg(message: "Either you cancelled the request or Apple reported a transaction error. Please try again later, or contact the app's customer support for assistance.")
                    }
                    
                case .purchasing:
                    self.isLoading = true
                    
                case .deferred:
                    self.isLoading = false
                    self.showAlertMsg(message: "Purchase is pending approval.")
                    
                @unknown default:
                    break
                }
            }
        }
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        DispatchQueue.main.async {
            self.isLoading = false
            self.isRestoring = false
            
            if queue.transactions.isEmpty {
                self.showAlertMsg(message: "No previous purchase found to restore.")
            }
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        DispatchQueue.main.async {
            self.isLoading = false
            self.isRestoring = false
            self.showAlertMsg(message: "Restore failed: \(error.localizedDescription)")
        }
    }
    
    private func sortIndex(_ id: String) -> Int {
        PremiumPlan.enabledPlans.firstIndex(where: { $0.productID == id }) ?? 99
    }
    
    private func showAlertMsg(message: String) {
        alertMessage = message
        showAlert = true
    }
    
    func openURL(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
}

// MARK: - Product Enum
enum Products: String, CaseIterable {
    case lifetime = "Life_korvani"
    case yearly = "Year_korvani"
    case monthly = "Month_korvani"
    case weekly = "Week_korvani"
}
