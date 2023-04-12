//
//  CurrentWeatherData.swift
//  WeatherApp
//
//  Created by Дарья Бирюкова on 12.04.2023.
//

import Foundation

//создаем модель, чтобя извлечь из JSON необходимые данные
struct CurrentWeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
    let feels_like: Double
}

//чтобы изменить название ключа, по кот.мы получаем значение из json, используем enum
//enum CodingKeys: String, CodingKey {
  //  case temp
  //  case feelsLike = "feels_like"
//}

struct Weather: Codable {
    let id: Int
}
