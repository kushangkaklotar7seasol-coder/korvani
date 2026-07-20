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
            WeatherDesign.Background()
            
            VStack {
                DefaultDesign.Header(name: Strings.weather, icon: "ic_purple_back", back: {
                    self.dismiss()
                })
                .padding(.horizontal, 16)
                
                VStack {
                    Text(Date.now, format: .dateTime.weekday(.wide).month(.wide).day())
                        .font(.system(size: 16, weight: .regular))
                    
                    Text(locationManager.addressString)
                        .font(.system(size: 22, weight: .semibold))
                    
                    ZStack {
                        if viewModel.selectedDay != nil {
                            KFImage.url(URL(string: Utility.getWeatherImageUrl(viewModel.selectedDay?.weather.first?.icon ?? "")))
                                .resizable()
                                .scaledToFill()
                        } else {
                            DefaultDesign.Loader()
                                .frame(width: 100, height: 100, alignment: .center)
                        }
                    }
                    .frame(width: 160, height: 160, alignment: .center)
                }
                .padding(.top, 24)
                .padding(.horizontal, 16)
                
                
                HStack {
                    VStack(spacing: 8) {
                        let tempStr = "\(viewModel.selectedDay?.main.temp ?? 0.0)".prefix(2)
                        Text("\(tempStr)° C")
                            .font(.system(size: 44, weight: .semibold))
                        
                        Text("\(viewModel.selectedDay?.weather.first?.description ?? "")")
                            .padding(.horizontal, 12)
                            .padding(.vertical, 7)
                            .background(.lightBlackColour)
                            .cornerRadius(10)
                        
                        let tempMaxStr = "\(viewModel.selectedDay?.main.tempMax ?? 0.0)".prefix(2)
                        let tempMinStr = "\(viewModel.selectedDay?.main.tempMin ?? 0.0)".prefix(2)
                        Text("H: \(tempMaxStr)°  L: \(tempMinStr)°")
                            .font(.system(size: 12, weight: .semibold))
                    }
                    
                    Spacer()
                    
                    VStack {
                        let tempMaxStr = "\(viewModel.selectedDay?.main.tempMax ?? 0.0)".prefix(2)
                        let humidityStr = "\(viewModel.selectedDay?.main.humidity ?? 0)".prefix(2)
                        let windStr = "\(viewModel.selectedDay?.wind.speed ?? 0.0)".prefix(2)
                        
                        WeatherDesign.Info(image: "ic_temp", name: Strings.maximum, value: "\(tempMaxStr)° C")
                        WeatherDesign.Info(image: "ic_humidity", name: Strings.humidity, value: "\(humidityStr)%")
                        WeatherDesign.Info(image: "ic_wind", name: Strings.wind, value: "\(windStr)km/h")
                    }
                }
                .padding(.horizontal, 50)
                .padding(.horizontal, 16)
                
                VStack(alignment: .leading) {
                    
                    HStack {
                        Text(Strings.forecast)
                            .font(.system(size: 18, weight: .semibold))
                        
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(viewModel.weeklyForecast, id: \.id) { item in
                                WeatherDesign.ForeCast(isToday: viewModel.selectedDay?.id == item.id, detail: item)
                                    .onTapGesture {
                                        viewModel.selectedDay = item
                                    }
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
