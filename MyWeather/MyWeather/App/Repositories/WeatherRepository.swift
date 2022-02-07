//
//  WeatherRepository.swift
//  MyWeather
//
//  Created by Muthama Kahohi on 06/02/2022.
//

import Foundation

class WeatherRepository {
    
    let networkManager: NetworkManager
    private let apiKey: String = "d9d744456c0923d00651e15f22db3cf1"

    init() {
        networkManager = NetworkManager.shared
    }
    
    func fetchCurrentWeatherData(longitude: String, latitude: String, completion: @escaping (Result<CurrentWeatherDataResponse, Error>) -> Void) {
       
        let queryItems = ["lat": latitude, "lon": longitude, "appid": apiKey, "units": "metric"]
        
        let currentWeatherRequest =  CurrentWeatherRequest(queryItems: queryItems)

        networkManager.request(currentWeatherRequest) { result in
            switch result {
            case .success(let currentWeather):
                completion(.success(currentWeather))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchWeatherForecast(longitude: String, latitude: String, completion: @escaping (Result<WeatherForecastResponse, Error>) -> Void) {
        
        let queryItems = ["lat": latitude, "lon": longitude, "appid": apiKey, "units": "metric"]
        let weatherForecastRequest = WeatherForecastRequest(queryItems: queryItems)

        networkManager.request(weatherForecastRequest) { result in
            switch result {
            case .success(let forecast):
                print(forecast)
                completion(.success(forecast))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
