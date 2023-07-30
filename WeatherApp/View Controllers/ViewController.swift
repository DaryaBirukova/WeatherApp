//
//  ViewController.swift
//  WeatherApp
//
//  Created by Дарья Бирюкова on 11.07.2023.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    let backView = UIImageView()
    let backImage = UIImage(named: "Background day.jpg")
    let weatherIconView = UIImageView()
    let weatherIconImage = UIImage(systemName: "sun.min.fill")
    let temperatureLabel = UILabel()
    let feelsLikeTemperatureLabel = UILabel()
    let cityLabel = UILabel()
    let searchButton = UIButton()
    
    let weatherIconSize = CGFloat(180)
    let temperatureLabelWidth = CGFloat(150)
    let temperatureLabelHeight = CGFloat(40)
    let searchButtonSize = CGFloat(80)
    let areaTemperatureLabel = CGFloat(280)
    let areaBetweenElements = CGFloat(50)
    let constraintSize = CGFloat(25)
    let topConstraint = CGFloat(500)
    let labelSize = CGFloat(40)
    
    var networkWeatherManager = NetworkWeatherManager()
    
    lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestWhenInUseAuthorization()
        return locationManager
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addWeatherUI()
        networkWeatherManager.onCompletion = { [weak self] currentWeather in
            guard let self = self else { return }
            self.updateInterfaceWith(weather: currentWeather)
        }
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.requestLocation()
            }
        }
    }
    
    @objc func searchButtonPressed(sender: UITapGestureRecognizer) {
        self.presentSearchAlertController(withTitle: "Enter city name", message: nil, style: .alert) { [unowned self] city in //unowned гарантирует, что self сущ-т на момент завершения работы клоужера
            self.networkWeatherManager.getCurrentWeather(forRequestType: .cityName(city: city))
        }
    }
    
    // MARK: - AddWeatherUI
    
    func addWeatherUI() {
        
        backView.frame = CGRect(x: view.frame.minX,
                                y: view.frame.minY,
                                width: view.frame.maxX,
                                height: view.frame.maxY
        )
        backView.backgroundColor = .clear
        backView.contentMode = UIView.ContentMode.scaleAspectFill
        backView.image = backImage
        self.view.addSubview(backView)
        
        backView.translatesAutoresizingMaskIntoConstraints = false
        backView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        backView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        backView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        backView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        
        weatherIconView.frame = CGRect(x: view.frame.midX - weatherIconSize / 2,
                                       y: view.frame.minY + 1.5 * areaBetweenElements,
                                       width: weatherIconSize,
                                       height: weatherIconSize
        )
        weatherIconView.backgroundColor = .clear
        weatherIconView.contentMode = .scaleAspectFill
        weatherIconView.image = weatherIconImage
        weatherIconView.tintColor = .yellow
        self.view.addSubview(weatherIconView)
        
        weatherIconView.translatesAutoresizingMaskIntoConstraints = false
        weatherIconView.widthAnchor.constraint(equalToConstant: weatherIconSize).isActive = true
        weatherIconView.heightAnchor.constraint(equalToConstant: weatherIconSize).isActive = true
        weatherIconView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        weatherIconView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.minY + 1.5 * constraintSize).isActive = true
        
        temperatureLabel.frame = CGRect(x: CGFloat(view.frame.midX - temperatureLabelWidth / 2),
                                        y: CGFloat(view.frame.minY + areaTemperatureLabel),
                                        width: temperatureLabelWidth,
                                        height: temperatureLabelHeight
        )
        temperatureLabel.text = "25°C"
        temperatureLabel.textColor = .yellow
        temperatureLabel.textAlignment = .center
        temperatureLabel.font = UIFont.systemFont(ofSize: labelSize)
        temperatureLabel.font = .boldSystemFont(ofSize: labelSize)
        self.view.addSubview(temperatureLabel)
        
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        temperatureLabel.heightAnchor.constraint(equalToConstant: temperatureLabelHeight).isActive = true
        temperatureLabel.topAnchor.constraint(equalTo: weatherIconView.bottomAnchor, constant: constraintSize).isActive = true
        
        feelsLikeTemperatureLabel.frame = CGRect(x: CGFloat(view.frame.midX - temperatureLabelWidth / 2),
                                                 y: CGFloat(view.frame.minY + temperatureLabelHeight + areaTemperatureLabel),
                                                 width: temperatureLabelWidth,
                                                 height: temperatureLabelHeight
        )
        feelsLikeTemperatureLabel.text = "Feels like: 23°C"
        feelsLikeTemperatureLabel.textColor = .yellow
        feelsLikeTemperatureLabel.textAlignment = .left
        temperatureLabel.font = .boldSystemFont(ofSize: labelSize)
        self.view.addSubview(feelsLikeTemperatureLabel)
        
        feelsLikeTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        feelsLikeTemperatureLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        feelsLikeTemperatureLabel.heightAnchor.constraint(equalToConstant: temperatureLabelHeight).isActive = true
        feelsLikeTemperatureLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: constraintSize / 2).isActive = true
        
        searchButton.frame = CGRect(x: view.frame.maxX - areaBetweenElements - searchButtonSize / 2,
                                    y: view.frame.maxY - areaBetweenElements - searchButtonSize,
                                    width: searchButtonSize,
                                    height: searchButtonSize
        )
        searchButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        searchButton.tintColor = .yellow
        searchButton.backgroundColor = .clear
        searchButton.addTarget(self, action: #selector(searchButtonPressed(sender:)), for: .touchUpInside)
        self.view.addSubview(searchButton)
        
        cityLabel.frame = CGRect(x: view.frame.maxX - areaBetweenElements - searchButtonSize / 2 - temperatureLabelWidth,
                                 y: view.frame.maxY - areaBetweenElements - 0.75 * searchButtonSize,
                                 width: temperatureLabelWidth,
                                 height: temperatureLabelHeight
        )
        cityLabel.text = "Moscow"
        cityLabel.textColor = .yellow
        cityLabel.textAlignment = .right
        self.view.addSubview(cityLabel)
        
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        cityLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 2 * constraintSize).isActive = true
        cityLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: topConstraint).isActive = true
        cityLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 4 * constraintSize).isActive = true
        cityLabel.widthAnchor.constraint(equalToConstant: temperatureLabelWidth).isActive = true
        
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.topAnchor.constraint(equalTo: view.topAnchor, constant: topConstraint).isActive = true
        searchButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 4 * constraintSize).isActive = true
        searchButton.leadingAnchor.constraint(equalTo: cityLabel.trailingAnchor, constant: areaBetweenElements / 2).isActive = true
        
    }
    
    // MARK: - UpdateInterface
    
    func updateInterfaceWith(weather: CurrentWeather) {
        DispatchQueue.main.async {
            self.cityLabel.text = weather.cityName
            self.temperatureLabel.text = weather.temperatureString
            self.feelsLikeTemperatureLabel.text = weather.feelsLikeTemperatureString
            self.weatherIconView.image = UIImage(systemName: weather.systemIconNameString)
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        networkWeatherManager.getCurrentWeather(forRequestType: .coordinate(latitude: latitude, longitude: longitude))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

// MARK: - PresentSearchAlertController

extension ViewController {
    func presentSearchAlertController(withTitle title: String?, message: String?, style: UIAlertController.Style, completionHandler: @escaping (String) -> (Void)) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        alertController.addTextField { tf in
            let cities = ["Moscow", "Los Angeles", "Istanbul", "Phuket", "Novosibirsk"]
            tf.placeholder = cities.randomElement()
        }
        let search = UIAlertAction(title: "Search", style: .default) { action in
            let textField = alertController.textFields?.first
            guard let cityName = textField?.text else { return }
            if cityName != "" {
                let city = cityName.split(separator: " ").joined(separator: "%20") //для городов с двойным именем н-р ЛА
                completionHandler(city)
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(search)
        alertController.addAction(cancel)
        present(alertController, animated: true)
    }
}

