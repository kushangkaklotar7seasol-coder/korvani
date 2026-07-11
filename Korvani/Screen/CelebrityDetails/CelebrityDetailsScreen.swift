//
//  CelebrityDetailsScreen.swift
//  Korvani
//
//  Created by Kushang kaklotar on 11/07/26.
//

import SwiftUI

struct CelebrityDetailsScreen: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            VStack() {
                HStack {
                    Button {
                        self.dismiss()
                    } label: {
                        Image("ic_back")
                            .resizable()
                            .frame(width: 40, height: 40, alignment: .center)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
                
                ZStack {
                    LinearGradient(colors: [.clear, .blackColour], startPoint: .top,endPoint: .bottom)
                    
                    VStack {
                        Spacer()
                        
                        HStack {
                            VStack {
                                Text("Liam Rao")
                                    .font(.system(size: 24, weight: .semibold))
                                
                                Text("Actor, Producer")
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundColor(.grayColour)
                            }
                            .padding(16)
                            
                            Spacer()
                        }
                    }
                }
                .frame(width: screenWidth-32, height: screenWidth-32, alignment: .center)
                .background()
                .cornerRadius(16)
                .padding(.top, 24)
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("Biography")
                            .font(.system(size: 18, weight: .medium))
                        Spacer()
                    }
                    
                    Text("As Humanity faces its greatest existential threat, a team of daring explorers embarks on a mission beyond the known universe...")
                        .foregroundColor(.grayColour)
                }
                .padding(.horizontal, 16)
                .padding(.top, 29)
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("Personal info")
                            .font(.system(size: 18, weight: .medium))
                        Spacer()
                    }
                    
                    VStack {
                        VStack(spacing: 0) {
                            
                            HStack {
                                Circle()
                                    .foregroundColor(.orangeColour)
                                    .frame(width: 6, height: 6, alignment: .center)
                                
                                Text("kushang kaklotar")
                                
                                Spacer()
                                
                                Text("kushang kaklotar")
                            }
                            
                            HStack {
                                ZStack { }
                                    .frame(width: 2, height: 16)
                                    .background(.greenColour)
                                    .padding(.leading, 1.5)
                                
                                ZStack { }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 1)
                                    .background(.greenColour)
                                    .padding(.leading, 1.5)
                                    .padding(.top, 4)
                                
                                Spacer()
                            }
                        }
                        .padding()
                    }
                    .background(.lightBlackColour)
                    .cornerRadius(10)
                }
                .padding(.horizontal, 16)
                .padding(.top, 14)
                
                Spacer()
            }
        }
        .defaultPage()
    }
}

#Preview {
    CelebrityDetailsScreen()
}
