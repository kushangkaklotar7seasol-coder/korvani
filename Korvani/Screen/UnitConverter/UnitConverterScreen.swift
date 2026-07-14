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
    
    var body: some View {
        ZStack {
            VStack {
                //                       commonStatusbar(isBackBtnShow: true, text: str.UnitConverter)
                //                           .padding(.top)
                HStack(spacing: 0) {
                    
                    ForEach(UnitType.allCases, id: \.self) { type in
                        
                        Button {
                            withAnimation(.easeInOut(duration: 0.25)) {
                                viewModel.selectedType = type
                            }
                        } label: {
                            
                            Text(type.rawValue)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(
                                    viewModel.selectedType == type
                                    ? .red
                                    : .whiteColour
                                )
                                .frame(maxWidth: .infinity)
                                .frame(height: 40)
                                .background {
                                    
                                    if viewModel.selectedType == type {
                                        RoundedRectangle(cornerRadius: 28)
                                            .fill(.white)
                                            .padding(4)
                                    }
                                }
                        }
                        .buttonStyle(.plain)
                    }
                }
                .frame(height: 42)
                .background(.white.opacity(0.45))
                .cornerRadius(21)
                .padding(.horizontal,15)
                
                ZStack {
                    VStack(spacing:20) {
                        UnitConvertCard(
                            title: "str.FROM",
                            subtitle: "str.StandardInternationalUnit",
                            value: $viewModel.fromValue,
                            selectedUnit: $viewModel.fromUnit,
                            units: viewModel.selectedType.units,
                            isEditable: true
                        )
                        
                        UnitConvertCard(
                            title: "str.TO",
                            subtitle: "str.ImperialMeasurement",
                            value: $viewModel.toValue,
                            selectedUnit: $viewModel.toUnit,
                            units: viewModel.selectedType.units,
                            isEditable: false
                        )
                    }
                    
                    Button {
                        viewModel.swapUnits()
                    } label: {
                        Image("swap")
                            .resizable()
                            .frame(width: 60, height: 60)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal,15)
                .padding(.top,15)
                
                Spacer()
            }
        }
        .defaultPage()
    }
}

#Preview {
    UnitConverterScreen()
}
