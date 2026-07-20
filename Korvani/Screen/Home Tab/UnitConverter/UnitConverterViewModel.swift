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
        case Strings.meters:       meters = value
        case Strings.kilometers:   meters = value * 1_000
        case Strings.centimeters:  meters = value * 0.01
        case Strings.millimeters:  meters = value * 0.001
        case Strings.feet:         meters = value * 0.3048
        case Strings.inches:       meters = value * 0.0254
        case Strings.miles:        meters = value * 1_609.344
        case Strings.yards:        meters = value * 0.9144
        default:             meters = value
        }
        
        let result: Double
        switch toUnit {
        case Strings.meters:       result = meters
        case Strings.kilometers:   result = meters / 1_000
        case Strings.centimeters:  result = meters / 0.01
        case Strings.millimeters:  result = meters / 0.001
        case Strings.feet:         result = meters / 0.3048
        case Strings.inches:       result = meters / 0.0254
        case Strings.miles:        result = meters / 1_609.344
        case Strings.yards:        result = meters / 0.9144
        default:             result = meters
        }
        
        self.toValue = self.formatUnit(result)
    }
    
    // Base Unit: Kilograms
    private func convertUnitWeight(_ value: Double) {
        let kg: Double
        switch fromUnit {
        case Strings.kilograms:    kg = value
        case Strings.grams:        kg = value / 1_000
        case Strings.miligrams:    kg = value / 1_000_000
        case Strings.pounds:       kg = value * 0.453592
        case Strings.ounces:       kg = value * 0.0283495
        case Strings.tonnes:       kg = value * 1_000
        case Strings.stone:        kg = value * 6.35029
        default:                   kg = value
        }
        
        let result: Double
        switch toUnit {
        case Strings.kilograms:    result = kg
        case Strings.grams:        result = kg * 1_000
        case Strings.miligrams:    result = kg * 1_000_000
        case Strings.pounds:       result = kg / 0.453592
        case Strings.ounces:       result = kg / 0.0283495
        case Strings.tonnes:       result = kg / 1_000
        case Strings.stone:        result = kg / 6.35029
        default:                   result = kg
        }
        
        self.toValue = self.formatUnit(result)
    }
    
    // Base Unit: Meters per Second
    private func convertUnitSpeed(_ value: Double) {
        let mps: Double
        switch fromUnit {
        case Strings.mPerS:      mps = value
        case Strings.kmPerH:     mps = value / 3.6
        case Strings.mph:        mps = value * 0.44704
        case Strings.knots:      mps = value * 0.514444
        case Strings.ftPerS:     mps = value * 0.3048
        default:                 mps = value
        }
        
        let result: Double
        switch toUnit {
        case Strings.mPerS:      result = mps
        case Strings.kmPerH:     result = mps * 3.6
        case Strings.mph:        result = mps / 0.44704
        case Strings.knots:      result = mps / 0.514444
        case Strings.ftPerS:     result = mps / 0.3048
        default:         result = mps
        }
        
        self.toValue = self.formatUnit(result)
    }
    
    // Base Unit: Bytes (1 KB = 1000 Bytes - Decimal/SI Standard)
    private func convertUnitStorage(_ value: Double) {
        let bytes: Double
        switch fromUnit {
        case Strings.bytes:   bytes = value
        case Strings.kb:      bytes = value * pow(1000, 1)   // 1 KB = 1,000 Bytes
        case Strings.mb:      bytes = value * pow(1000, 2)   // 1 MB = 1,000,000 Bytes
        case Strings.gb:      bytes = value * pow(1000, 3)   // 1 GB = 1,000,000,000 Bytes
        case Strings.tb:      bytes = value * pow(1000, 4)   // 1 TB = 1,000,000,000,000 Bytes
        case Strings.pb:      bytes = value * pow(1000, 5)   // 1 PB = 1,000,000,000,000,000 Bytes
        default:        bytes = value
        }
        
        let result: Double
        switch toUnit {
        case Strings.bytes:  result = bytes
        case Strings.kb:     result = bytes / pow(1000, 1)
        case Strings.mb:     result = bytes / pow(1000, 2)
        case Strings.gb:     result = bytes / pow(1000, 3)
        case Strings.tb:     result = bytes / pow(1000, 4)
        case Strings.pb:     result = bytes / pow(1000, 5)
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

    var localized: String {
        switch self {
        case .length:
            return "LENGTH".localized()
        case .weight:
            return "WEIGHT".localized()
        case .speed:
            return "SPEED".localized()
        case .storage:
            return "STORAGE".localized()
        }
    }
    
    var units: [String] {
        switch self {
        case .length:
            return [Strings.meters, Strings.kilometers, Strings.centimeters, Strings.millimeters, Strings.feet, Strings.inches, Strings.miles, Strings.yards]

        case .weight:
            return [Strings.kilograms, Strings.grams, Strings.miligrams, Strings.pounds, Strings.ounces, Strings.tonnes, Strings.stone]

        case .speed:
            return [Strings.kmPerH, Strings.mph, Strings.mPerS, Strings.knots, Strings.ftPerS]

        case .storage:
            return [Strings.bytes, Strings.kb, Strings.mb, Strings.gb, Strings.tb, Strings.pb]
        }
    }
}
