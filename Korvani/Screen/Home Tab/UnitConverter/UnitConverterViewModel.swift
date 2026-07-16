//
//  UnitConverterViewModel.swift
//  Korvani
//
//  Created by Kushang kaklotar on 14/07/26.
//

import Foundation
internal import Combine

class UnitConverterViewModel: ObservableObject {
    @Published var selectedUnit: UnitType = .length {
        didSet { updateUnits() }
    }
    
    @Published var fromValue: String = "" {
        didSet { convertUnit() }
    }
    
    @Published var toValue: String = ""
    
    @Published var fromUnit: String = "Meters" {
        didSet { convertUnit() }
    }
    
    @Published var toUnit: String = "Kilometers" {
        didSet { convertUnit() }
    }
    
    init() {
        self.updateUnits()
    }
    
    func updateUnits() {
        let units = selectedUnit.units
        
        self.fromUnit = units.first ?? ""
        self.toUnit = units.count > 1 ? units[1] : units.first ?? ""
        
        self.fromValue = ""
        self.toValue = ""
    }
    
    func swapUnits() {
        let oldFrom = fromUnit
        self.fromUnit = toUnit
        self.toUnit = oldFrom
      
    }
    
    private func convertUnit() {
        let cleanedValue = fromValue
            .replacingOccurrences(of: ",", with: "")
            .replacingOccurrences(of: " ", with: "")
        
        guard let value = Double(cleanedValue) else {
            self.toValue = ""
            return
        }
        
        switch selectedUnit {
        case .length:   convertUnitLength(value)
        case .weight:   convertUnitWeight(value)
        case .speed:    convertUnitSpeed(value)
        case .storage:  convertUnitStorage(value)
        }
    }
    
    
    // Base Unit: Meters
    private func convertUnitLength(_ value: Double) {
        let meters: Double
        switch fromUnit {
        case "Meters":       meters = value
        case "Kilometers":   meters = value * 1_000
        case "Centimeters":  meters = value * 0.01
        case "Millimeters":  meters = value * 0.001
        case "Feet":         meters = value * 0.3048
        case "Inches":       meters = value * 0.0254
        case "Miles":        meters = value * 1_609.344
        case "Yards":        meters = value * 0.9144
        default:             meters = value
        }
        
        let result: Double
        switch toUnit {
        case "Meters":       result = meters
        case "Kilometers":   result = meters / 1_000
        case "Centimeters":  result = meters / 0.01
        case "Millimeters":  result = meters / 0.001
        case "Feet":         result = meters / 0.3048
        case "Inches":       result = meters / 0.0254
        case "Miles":        result = meters / 1_609.344
        case "Yards":        result = meters / 0.9144
        default:             result = meters
        }
        
        self.toValue = self.formatUnit(result)
    }
    
    // Base Unit: Kilograms
    private func convertUnitWeight(_ value: Double) {
        let kg: Double
        switch fromUnit {
        case "Kilograms":    kg = value
        case "Grams":        kg = value / 1_000
        case "Milligrams":   kg = value / 1_000_000
        case "Pounds":       kg = value * 0.453592
        case "Ounces":       kg = value * 0.0283495
        case "Tonnes":       kg = value * 1_000
        case "Stone":        kg = value * 6.35029
        default:             kg = value
        }
        
        let result: Double
        switch toUnit {
        case "Kilograms":    result = kg
        case "Grams":        result = kg * 1_000
        case "Milligrams":   result = kg * 1_000_000
        case "Pounds":       result = kg / 0.453592
        case "Ounces":       result = kg / 0.0283495
        case "Tonnes":       result = kg / 1_000
        case "Stone":        result = kg / 6.35029
        default:             result = kg
        }
        
        self.toValue = self.formatUnit(result)
    }
    
    // Base Unit: Meters per Second
    private func convertUnitSpeed(_ value: Double) {
        let mps: Double
        switch fromUnit {
        case "M/s":      mps = value
        case "Km/h":     mps = value / 3.6
        case "Mph":      mps = value * 0.44704
        case "Knots":    mps = value * 0.514444
        case "Ft/s":     mps = value * 0.3048
        default:         mps = value
        }
        
        let result: Double
        switch toUnit {
        case "M/s":      result = mps
        case "Km/h":     result = mps * 3.6
        case "Mph":      result = mps / 0.44704
        case "Knots":    result = mps / 0.514444
        case "Ft/s":     result = mps / 0.3048
        default:         result = mps
        }
        
        self.toValue = self.formatUnit(result)
    }
    
    // Base Unit: Bytes (1 KB = 1000 Bytes - Decimal/SI Standard)
    private func convertUnitStorage(_ value: Double) {
        let bytes: Double
        switch fromUnit {
        case "Bytes":   bytes = value
        case "KB":      bytes = value * pow(1000, 1)   // 1 KB = 1,000 Bytes
        case "MB":      bytes = value * pow(1000, 2)   // 1 MB = 1,000,000 Bytes
        case "GB":      bytes = value * pow(1000, 3)   // 1 GB = 1,000,000,000 Bytes
        case "TB":      bytes = value * pow(1000, 4)   // 1 TB = 1,000,000,000,000 Bytes
        case "PB":      bytes = value * pow(1000, 5)   // 1 PB = 1,000,000,000,000,000 Bytes
        default:        bytes = value
        }
        
        let result: Double
        switch toUnit {
        case "Bytes":   result = bytes
        case "KB":      result = bytes / pow(1000, 1)
        case "MB":      result = bytes / pow(1000, 2)
        case "GB":      result = bytes / pow(1000, 3)
        case "TB":      result = bytes / pow(1000, 4)
        case "PB":      result = bytes / pow(1000, 5)
        default:        result = bytes
        }
        
        self.toValue = self.formatUnit(result)
    }

    // MARK: - Formatter -
    private func formatUnit(_ value: Double) -> String {
        guard value != 0 else { return "0" }

        let absValue = abs(value)

        // Bahut chote ya bahut bade values ke liye scientific notation
        if absValue < 0.000001 || absValue >= 1_000_000_000_000 {
            // Native Swift format - reliable aur locale-independent
            let formatted = String(format: "%g", value)
            return formatted
        }

        // Normal values ke liye — trailing zeros hatao
        if value == value.rounded() && absValue < 1_000_000 {
            return String(Int64(value))
        }

        return String(format: "%.10g", value)
    }
}

enum UnitType: String, CaseIterable {
    case length  = "Length"
    case weight  = "Weight"
    case speed   = "Speed"
    case storage = "Storage"

    var units: [String] {
        switch self {
        case .length:
            return ["Meters", "Kilometers", "Centimeters", "Millimeters", "Feet", "Inches", "Miles", "Yards"]

        case .weight:
            return ["Kilograms", "Grams", "Milligrams", "Pounds", "Ounces", "Tonnes", "Stone"]

        case .speed:
            return ["Km/h", "Mph", "M/s", "Knots", "Ft/s"]

        case .storage:
            return ["Bytes", "KB", "MB", "GB", "TB", "PB"]
        }
    }
}
