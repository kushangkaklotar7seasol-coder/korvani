//
//  UnitConvertCard.swift
//  UtilityBox
//
//  Created by Vivek Rakholiya on 05/06/26.
//
import SwiftUI

struct UnitConvertCard: View {
    
    let title: String
    let subtitle: String
    
    @Binding var value: String
    @Binding var selectedUnit: String
    
    let units: [String]
    var isEditable: Bool = true
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 18) {
            
            HStack {
                
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                
                Spacer()
                
                Menu {
                    ForEach(units, id: \.self) { unit in
                        
                        Button(unit) {
                            selectedUnit = unit
                        }
                    }
                } label: {
                    
                    HStack(spacing: 6) {
                        
                        Text(selectedUnit)
                            .font(.system(size: 16,weight: .medium))
                        
                        Image(systemName: "chevron.down")
                    }
                    .padding(.horizontal, 14)
                    .frame(height: 29)
                    .background(Color("#F7F2FF"))
                    .cornerRadius(14.5)
                }
            }
            
            TextField("00", text: $value)
                .font(.system(size: 42, weight: .bold))
                .foregroundStyle(Color("#0C203A"))
                .padding(.horizontal, 18)
                .frame(height: 76)
                .overlay {
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(
                            Color("#D9C9F3"),
                            lineWidth: 1
                        )
                }
                .keyboardType(.decimalPad)
                .disabled(!isEditable)
                .onChange(of: value) { newValue in
                    
                    // ✅ Non-editable card (TO field) ke liye filter mat lagao
                    guard isEditable else { return }
                    
                    // Allow only digits and one decimal point
                    var filtered = newValue.filter {
                        $0.isNumber || $0 == "."
                    }

                    if filtered == "." {
                        value = "0."
                        return
                    }

                    let components = filtered.components(separatedBy: ".")

                    if components.count > 2 {
                        filtered = components[0] + "." + components.dropFirst().joined()
                    }

                    if filtered != newValue {
                        value = filtered
                    }
                }
            Text(subtitle)
                .font(.system(size: 16))
                .foregroundStyle(.secondary)
        }
        .padding(20)
        .background(.white.opacity(0.75))
        .cornerRadius(24)
    }
}
