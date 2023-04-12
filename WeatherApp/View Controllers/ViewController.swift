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
    //св-во lazy на случай, если польз-ль не одобрит делиться геопозицией
    lazy var locationManager: CLLocationManager = {
        let lm = CLLocationManager()
        lm.delegate = self
        lm.desiredAccuracy = kCLLocationAccuracyKilometer //выставляем точность определения геопозиции
        lm.requestWhenInUseAuthorization() //запрос на отслеживание геопозиции
        return lm
    }()
    
    @IBAction func searchPressed(_ sender: Any) {
        self.presentSearchAlertController(withTitle: "Enter city name", message: nil, style: .alert) { [unowned self] city in //unowned гарантирует, что self сущ-т на момент завершения работы клоужера
            self.networkWeatherManager.fetchCurrentWeather(forRequestType: .cityName(city: city))
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkWeatherManager.onCompletion = { [weak self] currentWeather in
            guard let self = self else { return }
            self.updateInterfaceWith(weather: currentWeather)
        }
        //если службы геопозиции отключены у пользователя в настройках делаем запрос
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
        }
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
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            //получаем последнюю локацию из массива локаций
            guard let location = locations.last else { return }
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
            networkWeatherManager.fetchCurrentWeather(forRequestType: .coordinate(latitude: latitude, longitude: longitude))
        }
        
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print(error.localizedDescription)
        }
    }
