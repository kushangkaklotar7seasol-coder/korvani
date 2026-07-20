//
//  UnitConverterScreen.swift
//  Korvani
//
//  Created by Kushang kaklotar on 14/07/26.
//

import SwiftUI

struct UnitConverterScreen: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel = UnitConverterViewModel()
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        ZStack {
            VStack {
                DefaultDesign.Header(name: "UNIT_CONVERTER", back: {
                    self.dismiss()
                })
                
                ScrollView(showsIndicators: false) {
                    HStack(spacing: 9) {
                        ForEach(UnitType.allCases, id: \.self) { type in
                            
                            Button {
                                withAnimation(.easeInOut(duration: 0.25)) {
                                    viewModel.selectedUnit = type
                                }
                            } label: {
                                Text(type.localized)
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(.whiteColour)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 40)
                                    .background {
                                        LinearGradient(
                                            colors: [viewModel.selectedUnit == type ? .lightYellowColour : .borderColour, viewModel.selectedUnit == type ? .orangeColour: .borderColour],
                                            startPoint: .top,
                                            endPoint: .bottom)
                                    }
                                    .cornerRadius(8)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.top, 24)
                    
                    ZStack {
                        VStack(spacing:20) {
                            UnitConvertCard(
                                title: "From",
                                value: $viewModel.fromValue,
                                selectedUnit: $viewModel.fromUnit,
                                isTextFieldFocused: _isTextFieldFocused,
                                units: viewModel.selectedUnit.units,
                                isEditable: true
                            )
                            
                            UnitConvertCard(
                                title: "To",
                                value: $viewModel.toValue,
                                selectedUnit: $viewModel.toUnit,
                                isTextFieldFocused: _isTextFieldFocused,
                                units: viewModel.selectedUnit   .units,
                                isEditable: false
                            )
                        }
                        
                        Button {
                            viewModel.swapUnits()
                        } label: {
                            Image("ic_swap")
                                .resizable()
                                .frame(width: 60, height: 60)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.top, 30)
                    
                    Spacer()
                }
            }
        }
        .padding(.horizontal, 16)
        .defaultPage()
        .contentShape(Rectangle())
        .onTapGesture {
            isTextFieldFocused = false
        }
    }
}

#Preview {
    UnitConverterScreen()
}
