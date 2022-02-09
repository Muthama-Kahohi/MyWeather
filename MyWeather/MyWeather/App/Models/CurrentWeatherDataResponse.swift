//
//  CurrentWeatherDataResponse.swift
//  MyWeather
//
//  Created by Muthama Kahohi on 07/02/2022.
//

import Foundation

struct CurrentWeatherDataResponse: Codable {
    let coord: Coordinates
    let weather: [WeatherData]
    let main: MainWeatherData
}

struct Coordinates: Codable {
    let lon, lat: Double
}

struct  WeatherData: Codable {
    let id: Int
    let main, description, icon: String
}

struct MainWeatherData: Codable {
    let temp, feels_like, temp_min, temp_max: Double
    let pressure, humidity: Int
}

