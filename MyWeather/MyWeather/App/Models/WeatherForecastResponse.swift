//
//  WeatherForecastResponse.swift
//  MyWeather
//
//  Created by Muthama Kahohi on 07/02/2022.
//

import Foundation

struct WeatherForecastResponse: Codable {
    let list: [WeatherForecastData]
}

