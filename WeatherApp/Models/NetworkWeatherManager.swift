//
//  NetworkWeatherManager.swift
//  WeatherApp
//
//  Created by Дарья Бирюкова on 12.04.2023.
//

import Foundation

class NetworkWeatherManager {
    
    var onCompletion: ((CurrentWeather) -> Void)?

    func fetchCurrentWeather(forCity city: String) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&apikey=\(apiKey)&units=metric"
        
        guard let url = URL(string: urlString) else { return }
        //вся работа с сетевыми запросами идет через сессию, поэтому создаем:
        let session = URLSession(configuration: .default)
        //создаем запрос:
        let task = session.dataTask(with: url) { data, response, error in
            if let data = data {
                if let currentWeather = self.parseJSON(withData: data) {
                    self.onCompletion?(currentWeather)
                }
            }
        }
        task.resume()
    }
    
    // данный метод парсит (раскладывает) данные по модели, которую мы создали
    func parseJSON(withData data: Data) -> CurrentWeather? {
        // для того, чтобы декодировать данные в наш формат:
        let decoder = JSONDecoder()
        // если мы используем decode, значит нужно использовать и try, а значит и do catch
        do {
            let currentWeatherData = try decoder.decode(CurrentWeatherData.self, from: data)
            guard let currentWeather = CurrentWeather(currentWeatherData: currentWeatherData) else {
                return nil
            }
            return currentWeather
        }
        
        catch let error as NSError {
            print("error: ", error)
        }
        return nil
    }
}
