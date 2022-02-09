//
//  WeatherForecastData.swift
//  MyWeather
//
//  Created by Muthama Kahohi on 07/02/2022.
//

import Foundation

struct WeatherForecastData: Codable {
    let main: MainWeatherData
    let weather: [WeatherData]
    let dt_txt: String
}
