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
    var coordinates = Coordinates(lon: 0.0, lat: 0.0)
    var cityName = ""

    init() {
        networkManager = NetworkManager.shared
    }
    
    func fetchCurrentWeatherData(weatherSearch: WeatherSearch,
                                 completion: @escaping (Result<CurrentWeatherDataResponse, Error>) -> Void) {
       
        let queryItems = returnWeatherSearchQueryItems(weatherSearch: weatherSearch)
        
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

    func fetchWeatherForecast(weatherSearch: WeatherSearch,
                              completion: @escaping (Result<WeatherForecastResponse, Error>) -> Void) {
        
        let queryItems = returnWeatherSearchQueryItems(weatherSearch: weatherSearch)
        let weatherForecastRequest = WeatherForecastRequest(queryItems: queryItems)

        networkManager.request(weatherForecastRequest) { result in
            switch result {
            case .success(let forecast):
                completion(.success(forecast))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

extension WeatherRepository {
    
    func returnWeatherSearchQueryItems(weatherSearch: WeatherSearch) -> [String: String] {
        var queryItems: [String: String] = [:]
        switch weatherSearch {
        case .myLocation:
            queryItems = ["lat": String(coordinates.lat),
                          "lon": String(coordinates.lon),
                          "appid": apiKey,
                          "units": "metric"]
        case .otherLocation:
            queryItems = ["q": cityName,
             "lon": String(coordinates.lon),
             "appid": apiKey,
             "units": "metric"]
        }
        
        return queryItems
    }
}
