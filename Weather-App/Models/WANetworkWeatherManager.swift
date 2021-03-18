//
//  WANetworkWeatherManager.swift
//  Weather-App
//
//  Created by Дарья Астапова on 1.03.21.
//

import Foundation
import CoreLocation

class WANetworkWeatherManager {
    enum RequestType {
        case cityName(city: String)
        case coordinate(latitude: CLLocationDegrees, longitude: CLLocationDegrees)
    }
    
    var onCompletion: ((WACurrentWeather) -> Void)?
    
    func fetchCurrentWeather(forRequestType type: RequestType) {
        var stringUrl = ""
        switch type {
        case .cityName(let city):
            stringUrl = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric"
        case .coordinate(let latitude, let longitude):
            stringUrl = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric"
        }
        
        self.performRequest(withStringUrl: stringUrl)
    }
    
    private func performRequest(withStringUrl stringUrl: String) {
        guard let url = URL(string: stringUrl) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, response, error) in
            if let data = data {
                if let currentWeather = self.parseJSON(withData: data) {
                    self.onCompletion?(currentWeather)
                }
            }
        }
        task.resume()
    }
    
    private func parseJSON(withData data: Data) -> WACurrentWeather? {
        let decoder = JSONDecoder()
        do {
            let currentWeatherData = try decoder.decode(WACurrentWeatherData.self,
                                                        from: data)
            return WACurrentWeather(currentWeatherData: currentWeatherData)
        } catch let error as NSError {
            print(error)
        }
        return nil
    }
}
