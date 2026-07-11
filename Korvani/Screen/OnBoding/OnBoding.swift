//
//  OnBoding.swift
//  Korvani
//
//  Created by Kushang kaklotar on 09/07/26.
//

import SwiftUI

struct OnBoding: View {
    
    @StateObject var viewModel = OnBordingViewModel()
    let columns = [GridItem(.flexible())]
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                TabView(selection: $viewModel.selectedTab) {
                    ForEach(viewModel.information.indices, id: \.self) { index in
                        OnBording.TopView(info: viewModel.information[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                Spacer()
                
                HStack {
                    ForEach(viewModel.information.indices, id: \.self) { index in
                        ZStack { }
                            .frame(width: 8, height: 8, alignment: .center)
                            .background(
                                LinearGradient(
                                    colors: [viewModel.selectedTab == index ? .lightYellowColour : .gray, viewModel.selectedTab == index ? .orangeColour : .gray],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .cornerRadius(4)
                    }
                }
                .padding(.bottom, 10)
                
                Button {
                    if viewModel.selectedTab == viewModel.information.count-1 {
                        DispatchQueue.main.async {
                            UserdefaultManager.shared.saveOnBoard(0)
                            
                            withAnimation {
                                viewModel.isShowHome = true
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            viewModel.selectedTab += 1
                        }
                    }
                } label: {
                    Text(viewModel.selectedTab == viewModel.information.count-1 ? Strings.gotIt : Strings.next)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: screenWidth-32, height: 55)
                        .background(
                            LinearGradient(
                                colors: [.lightYellowColour, .orangeColour],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .cornerRadius(14)
                        .animation(.easeInOut, value: viewModel.selectedTab == viewModel.information.count-1)
                }
                .padding(.bottom, 40)
                .background(.clear)
            }
        }
        .defaultPage()
        .frame(width: screenWidth, height: screenHeight, alignment: .center)
        .navigationDestination(isPresented: $viewModel.isShowHome) {
            HomeScreen()
                .toolbar(.hidden, for: .navigationBar)
        }
    }
}

#Preview {
    OnBoding()
}

class OnBording {
    struct TopView: View {
        var info: OnBordingInfo
        
        var body: some View {
            ZStack {
                VStack {
                    Image(info.image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    
                    Spacer()
                }
                
                LinearGradient(colors: [.clear, .blackColour], startPoint: .center, endPoint: .bottom)
                
                VStack {
                    Spacer()
                    
                    Text(info.name)
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text(info.info)
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.top, 6)
                        .padding(.horizontal)
                    
                    Spacer().frame(height: 30)
                    
                    if info.moreInfo != nil {
                        HStack(spacing: 15) {
                            Image("ic_info")
                                .frame(width: 40, height: 40)
                            
                            VStack(alignment: .leading, spacing: 7) {
                                Text(Strings.infoOnly)
                                    .font(.system(size: 12, weight: .medium))
                                
                                Text(info.moreInfo ?? "")
                                    .multilineTextAlignment(.leading)
                                    .font(.system(size: 12, weight: .regular))
                                    .foregroundColor(.grayColour)
                            }
                        }
                        .padding(16)
                        .background(.lightBlackColour)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.lightborderColour, lineWidth: 1)
                        )
                        .padding(.bottom, 24)
                        .padding(16)
                    }
                }
//                .lineLimit(2)
                .multilineTextAlignment(.center)
                
            }
            .ignoresSafeArea()
        }
    }
}
