//
//  WeatherResponse.swift
//  MyWeather
//
//  Created by Muthama Kahohi on 06/02/2022.
//

import Foundation

struct WeatherResponse<T: Decodable>: Decodable {
    var result: T
}
