//
//  HomeWeatherViewModel.swift
//  MyWeather
//
//  Created by Muthama Kahohi on 06/02/2022.
//

import Foundation
import UIKit

class HomeWeatherViewModel {
    
    let repository: WeatherRepository
    var cellModels: [CurentCellModel] = []
    var forecastCellModels: [ForecastCellModel] = []
    var weatherSearch: WeatherSearch = .myLocation
    let defaults = UserDefaultsWrapper.shared
    
    var coordinates: Coordinates = Coordinates(lon: 0, lat: 0)
    var city: String = ""
    
    init(repository: WeatherRepository) {
        self.repository = repository
    }
    
    func fetchCurrentWeatherData(completion: @escaping (Result<WeatherBannerModel, Error>) -> Void) {
        setRepoDetails()
        repository.fetchCurrentWeatherData(weatherSearch: weatherSearch) { [weak self] result in
            switch result {
            case .success(let currentWeather):
                guard let weatherType = self?.returnWeatherType(weatherData: currentWeather.weather) else { return }
                let weatherBannerModel = WeatherBannerModel(image: weatherType.image,
                                                            temperature: String(format: "degrees_symbol".localized(),
                                                                                String(currentWeather.main.temp)),
                                                            main: weatherType.rawValue.uppercased(),
                                                            bgColor: weatherType.bgColor)
                
                self?.setCellModels(currentWeather: currentWeather, weatherType: weatherType)
                completion(.success(weatherBannerModel))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func returnWeatherType(weatherData: [WeatherData]) -> WeatherType? {
        
        var weatherType: WeatherType?
        
        guard let weather = weatherData.first else { return .cloudy }
        let weatherPrefix = weather.main.prefix(1).lowercased()
        
        switch weatherPrefix {
        case WeatherType.sunny.rawValue.prefix(1):
            weatherType = .sunny
        case WeatherType.rainy.rawValue.prefix(1):
            weatherType = .rainy
        case WeatherType.cloudy.rawValue.prefix(1):
            weatherType = .cloudy
        default:
            return nil
        }
        
        return weatherType
    }
    
    func setCellModels(currentWeather: CurrentWeatherDataResponse, weatherType: WeatherType) {
        cellModels = [
            CurentCellModel(topText: String(format: "degrees_symbol".localized(),
                                            String(currentWeather.main.temp_min)),
                            bottomText: "min_text".localized(),
                            bgColor: weatherType.bgColor),
            
            CurentCellModel(topText: String(format: "degrees_symbol".localized(),
                                            String(currentWeather.main.temp)),
                            bottomText: "current_text".localized(),
                            bgColor: weatherType.bgColor),
            
            CurentCellModel(topText: String(format: "degrees_symbol".localized(),
                                            String(currentWeather.main.temp_max)),
                            bottomText:  "max_text".localized(),
                            bgColor: weatherType.bgColor)
        ]
    }
    
    func setForecastCellModels(weatherForecastData: [WeatherForecastData]) {
        
        forecastCellModels = weatherForecastData.map { currentWeather in
            guard
                let weatherType = self.returnWeatherType(weatherData: currentWeather.weather)
            else { return ForecastCellModel(firstText: "",
                                            lastText: "",
                                            icon: nil,
                                            iconTint: .clear) }
            
            return ForecastCellModel(firstText: currentWeather.dt_txt.convertDateFormat(fromDateFormat: .weatherApiDateFormat,
                                                                                        toDateFormat: .homeSceneWeatherFormat),
                                     lastText:  String(format: "degrees_symbol".localized(),
                                                       String(currentWeather.main.temp)) ,
                                     icon: weatherType.icon,
                                     iconTint: .white)
        }
    }
    
    func fetchWeatherForecast(completion: @escaping (Result<WeatherForecastResponse, Error>)-> Void) {
        setRepoDetails()
        repository.fetchWeatherForecast(weatherSearch: weatherSearch) { [weak self] result in
            switch result {
            case .success(let forecast):
                self?.setForecastCellModels(weatherForecastData: forecast.list)
                completion(.success(forecast))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func setRepoDetails() {
        repository.cityName = city
        repository.coordinates = coordinates
    }
    
    func saveCity(completion: @escaping (String) -> Void) {
        var favouriteCities = defaults.array(forKey: .favoriteCities)
        favouriteCities.append(city.capitalized)
        defaults.set(favouriteCities, forKey: .favoriteCities)
        completion("success_save".localized())
    }
    
    func fetchFavouriteCities() -> [String] {
        return defaults.array(forKey: .favoriteCities)
    }
}

struct WeatherBannerModel {
    let image: UIImage?
    let temperature, main: String
    let bgColor: UIColor
}

struct CurentCellModel {
    let topText, bottomText: String
    let bgColor: UIColor
}

struct ForecastCellModel {
    let firstText, lastText: String
    let icon: UIImage?
    let iconTint: UIColor
}
