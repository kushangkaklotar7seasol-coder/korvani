//
//  Weather.swift
//  Korvani
//
//  Created by Kushang kaklotar on 13/07/26.
//

import SwiftUI
import Kingfisher

struct Weather: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel = WeatherViewModel()
    
    var body: some View {
        ZStack {
            Text("Weather")
        }
        .defaultPage()
        .onAppear {
            // SwipeBackManager.shared.isEnabled = true
        }
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
        var image: String
        var name: String
        var value: String
        
        var body: some View {
            HStack {
                Image(image)
                    .resizable()
                    .frame(width: 44, height: 44, alignment: .center)
                
                VStack {
                    Text(name)
                        .font(.system(size: 12, weight: .regular))
                    
                    Text(value)//26° C
                        .font(.system(size: 16, weight: .medium))
                }
            }
        }
    }
    
    struct ForeCast: View {
        var isToday: Bool
        var detail: ForecastItem
        
        var body: some View {
            VStack {
                Text(dayName(from: detail.dtTxt))
                
                ZStack {
                    KFImage.url(URL(string: Utility.getWeatherImageUrl(detail.weather.first?.icon ?? "")))
                        .resizable()
                        .scaledToFill()
                }
                .frame(width: 60, height: 60, alignment: .center)
                
                let tempStr = "\(detail.main.temp)".prefix(2)
                Text("\(tempStr)°")
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
        
        func dayName(from dateString: String) -> String {
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            guard let date = formatter.date(from: dateString)
            else { return "" }
            
            let output = DateFormatter()
            output.dateFormat = "EEE"
            
            return output.string(from: date)
        }
    }
}
