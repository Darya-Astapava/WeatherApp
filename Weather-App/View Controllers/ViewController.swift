//
//  ViewController.swift
//  Weather-App
//
//  Created by Дарья Астапова on 1.03.21.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var weatherIconImage: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var feelsLikeTemperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    var networkWeatherManager = WANetworkWeatherManager()
    lazy var locationManager: CLLocationManager = {
        let lm = CLLocationManager()
        
        lm.delegate = self
        lm.desiredAccuracy = kCLLocationAccuracyKilometer
        lm.requestWhenInUseAuthorization()
        
        return lm
    }()
    
    // MARK: - Actions
    @IBAction func pressSearchButton(_ sender: UIButton) {
        self.presentSearchAlert(withTitle: "Enter city name",
                                message: nil,
                                style: .alert) { [weak self] (city) in
            self?.networkWeatherManager.fetchCurrentWeather(
                forRequestType: .cityName(city: city))
        }
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.networkWeatherManager.onCompletion = { [weak self] currentWeather in
            self?.updateInterfaceWith(weather: currentWeather)
        }

        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.requestLocation()
        }
    }

    private func updateInterfaceWith(weather: WACurrentWeather) {
        DispatchQueue.main.async {
            self.cityLabel.text = weather.cityName
            self.temperatureLabel.text = weather.temperatureString
            self.feelsLikeTemperatureLabel.text = weather.feelsLikeTemperatureString
            self.weatherIconImage.image = UIImage(systemName: weather.systemIconNameString)
        }
    }
}

// MARK: CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        networkWeatherManager.fetchCurrentWeather(
            forRequestType: .coordinate(latitude: latitude, longitude: longitude))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

