//
//  CurrentWeatherData.swift
//  WeatherApp
//
//  Created by Дарья Бирюкова on 11.07.2023.
//

import Foundation

struct CurrentWeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
    let feels_like: Double
}

struct Weather: Codable {
    let id: Int
}
