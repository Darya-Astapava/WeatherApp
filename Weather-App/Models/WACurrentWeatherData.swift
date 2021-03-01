//
//  WACurrentWeatherData.swift
//  Weather-App
//
//  Created by Дарья Астапова on 1.03.21.
//

import Foundation

struct WACurrentWeatherData: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Decodable {
    let temp: Double
    let feelsLike: Double
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
    }
}

struct Weather: Decodable {
    let id: Int
}
