//
//  WeatherViewModel.swift
//  Weahter App
//
//  Created by Pedro Alejandro on 11/30/20.
//

import Foundation

private let defaultIcon = "❓"
private let iconMap = [
    "Drizzle": "🌧",
    "Thunderstorm": "⛈",
    "Rain" : "🌧",
    "Snow" : "🌨",
    "Clear": "☀️",
    "Clouds": "☁️"
]

public class WeatherViewModel: ObservableObject{
    @Published var cityName: String = "City Name"
    @Published var temperature: String = "--"
    @Published var weatherDescription: String = "--"
    @Published var wehaterIcon : String = defaultIcon
    
    public let weatherService: WeatherServices
    
    public init(weatherService: WeatherServices){
        self.weatherService = weatherService
    }
    
    public func refresh(){
        weatherService.loadWeatherData{weather in
            DispatchQueue.main.async {
                self.cityName = weather.city
                self.temperature = "\(weather.temperature)˚F"
                self.weatherDescription = weather.description.capitalized
                self.wehaterIcon = iconMap[weather.iconName] ?? defaultIcon
            }
        }
    }
}
