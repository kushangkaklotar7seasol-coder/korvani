//
//  UnitConvertCard.swift
//  UtilityBox
//
//  Created by Vivek Rakholiya on 05/06/26.
//
import SwiftUI

struct UnitConvertCard: View {
    
    let title: String
//    let subtitle: String
    
    @Binding var value: String
    @Binding var selectedUnit: String
    @FocusState var isTextFieldFocused: Bool
    
    let units: [String]
    var isEditable: Bool = true
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            
            VStack(alignment: .leading) {
                
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.grayColour)
                
                
                Menu {
                    ForEach(units, id: \.self) { unit in
                        
                        Button(unit) {
                            selectedUnit = unit
                        }
                    }
                } label: {
                    HStack() {
                        Text(selectedUnit)
                            .font(.system(size: 24,weight: .semibold))
                        
                        Spacer()
                        
                        Image(systemName: "chevron.down")
                    }
                }
                .padding(.top, 10)
                
                Divider()
                    .background(.grayColour.opacity(0.3))
            }
            
            TextField("00", text: $value)
                .font(.system(size: 40, weight: .medium))
                .foregroundStyle(.whiteColour)
                .keyboardType(.decimalPad)
                .disabled(!isEditable)
                .focused($isTextFieldFocused)
                .padding(.top)
                .onChange(of: value) { newValue in
                    guard isEditable else { return }
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
        }
        .padding(20)
        .background(.borderColour)
        .cornerRadius(24)
    }
}
