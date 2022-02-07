//
//  ViewModelFactory.swift
//  MyWeather
//
//  Created by Muthama Kahohi on 06/02/2022.
//

import Foundation

class ViewModelFactory {
    static func homeWeather(repository: WeatherRepository) -> HomeWeatherViewModel {
        return HomeWeatherViewModel(repository: repository)
    }
}
