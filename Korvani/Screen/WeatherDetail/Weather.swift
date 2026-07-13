//
//  Weather.swift
//  Korvani
//
//  Created by Kushang kaklotar on 13/07/26.
//

import SwiftUI

struct Weather: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel = WeatherViewModel()
    
    var body: some View {
        ZStack {
            WeatherDesign.Background()
            
            VStack {
                DefaultDesign.Header(name: "Weather", icon: "ic_purple_back") {
                    self.dismiss()
                }
                .padding(.horizontal, 16)
                
                VStack {
                    Text(Date.now, format: .dateTime.weekday(.wide).month(.wide).day())
                        .font(.system(size: 14, weight: .regular))
                    
                    Text("New York, USA")
                        .font(.system(size: 22, weight: .semibold))
                    
                    ZStack { }
                        .frame(width: 120, height: 120, alignment: .center)
                        .background(.whiteColour)
                }
                .padding(.top, 24)
                .padding(.horizontal, 16)
                
                
                HStack {
                    VStack(spacing: 8) {
                        Text("26° C")
                            .font(.system(size: 44, weight: .semibold))
                        
                        Text("Partly Sunny")
                            .padding(.horizontal, 12)
                            .padding(.vertical, 7)
                            .background(.lightBlackColour)
                            .cornerRadius(10)
                        
                        Text("H: 26°  L: 24°")
                            .font(.system(size: 12, weight: .semibold))
                    }
                    
                    Spacer()
                    
                    VStack {
                        WeatherDesign.Info()
                        WeatherDesign.Info()
                        WeatherDesign.Info()
                    }
                }
                .padding(.horizontal, 50)
                .padding(.horizontal, 16)
                
                VStack(alignment: .leading) {
                    
                    HStack {
                        Text("7-Day Forecast")
                            .font(.system(size: 18, weight: .semibold))
                        
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(viewModel.weathers?.list ?? [], id: \.id) { item in
                                WeatherDesign.ForeCast(isToday: false)
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }
                .padding(.top, 34)
                
                
                Spacer()
            }
            
        }
        .defaultPage()
    }
}

#Preview {
    Weather()
}

class WeatherDesign {
    struct Background: View {
        var body: some View {
            VStack(spacing: 0) {
                LinearGradient(colors: [.darkPurpleColour, .blackColour], startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                
                ZStack { }
                    .frame(width: screenWidth, height: screenHeight/3.5)
                    .background(.blackColour)
            }
        }
    }
    
    struct Info: View {
        var body: some View {
            HStack {
                Image("ic_temp")
                    .resizable()
                    .frame(width: 44, height: 44, alignment: .center)
                
                VStack {
                    Text("Maximum")
                        .font(.system(size: 12, weight: .regular))
                    
                    Text("26° C")
                        .font(.system(size: 16, weight: .medium))
                }
            }
        }
    }
    
    struct ForeCast: View {
        var isToday: Bool
        
        var body: some View {
            VStack {
                Text("Mon")
                
                ZStack { }
                    .frame(width: 30, height: 30, alignment: .center)
                    .background(.whiteColour)
                
                Text("26°")
                    .font(.system(size: 22, weight: .medium))
            }
            .padding()
            .background(.lightBlackColour)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(
                        LinearGradient(
                            colors: [isToday ? .lightYellowColour : .borderColour, isToday ? .orangeColour: .borderColour],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: isToday ? 2 : 1
                    )
            )
        }
    }
}
