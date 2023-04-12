//
//  ViewController.swift
//  WeatherApp
//
//  Created by Дарья Бирюкова on 12.04.2023.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var feelsLikeTemperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    var networkWeatherManager = NetworkWeatherManager()
    lazy var locationManager: CLLocationManager = {
        let lm = CLLocationManager()
        lm.delegate = self
        lm.desiredAccuracy = kCLLocationAccuracyKilometer //выставляем точность определения геопозиции
        lm.requestWhenInUseAuthorization() //запрос на отслеживание геопозиции
        return lm
    }()
    
    @IBAction func searchPressed(_ sender: Any) {
        self.presentSearchAlertController(withTitle: "Enter city name", message: nil, style: .alert) { [unowned self] city in //unowned гарантирует, что self сущ-т на момент завершения работы клоужера
            self.networkWeatherManager.fetchCurrentWeather(forCity: city)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkWeatherManager.onCompletion = { [weak self] currentWeather in
            guard let self = self else { return }
            self.updateInterfaceWith(weather: currentWeather)
        }
        networkWeatherManager.fetchCurrentWeather(forCity: "London")
    }
        
    func updateInterfaceWith(weather: CurrentWeather) {
            DispatchQueue.main.async {
        self.cityLabel?.text = weather.cityName
        self.temperatureLabel.text = weather.temperatureString
        self.feelsLikeTemperatureLabel.text = weather.feelsLikeTemperatureString
        self.weatherIconImageView.image = UIImage(systemName: weather.systemIconNameString)
            }
        }
}

    // MARK: - CLLocationManagerDelegate

    extension ViewController: CLLocationManagerDelegate {
        
    }
