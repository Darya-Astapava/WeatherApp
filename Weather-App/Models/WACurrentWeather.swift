//
//  WACurrentWeather.swift
//  Weather-App
//
//  Created by Дарья Астапова on 1.03.21.
//

import Foundation

struct WACurrentWeather {
    let cityName: String
    
    let temperature: Double
    var temperatureString: String {
        return String(format: "%.0f", temperature)
    }
    
    let feelsLikeTemperature: Double
    var feelsLikeTemperatureString: String {
        return String(format: "%.0f", feelsLikeTemperature)
    }
    
    let conditionCode: Int
    var systemIconNameString: String {
        switch conditionCode {
        case 200...232: return "cloud.bolt.rain.fill"
        case 300...321: return "cloud.drizzle.fill"
        case 500...531: return "cloud.rain.fill"
        case 600...622: return "cloud.snow.fill"
        case 700...781: return "cloud.fog.fill"
        case 800: return "sun.max.fill"
        case 801...804: return "cloud.fill"
        default: return "nosign"
            
        }
    }
    
    init?(currentWeatherData: WACurrentWeatherData) {
        self.cityName = currentWeatherData.name
        self.temperature = currentWeatherData.main.temp
        self.feelsLikeTemperature = currentWeatherData.main.feelsLike
        self.conditionCode = currentWeatherData.weather.first?.id ?? 0
    }
}
