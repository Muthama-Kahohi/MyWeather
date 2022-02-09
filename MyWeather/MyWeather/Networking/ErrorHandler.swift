//
//  ErrorHandler.swift
//  MyWeather
//
//  Created by Muthama Kahohi on 06/02/2022.
//

import Foundation
enum MyWeatherError: Error {
    case custom(Int, String)
    case other
}

extension Error {
    var asWeatherError: MyWeatherError? {
        self as? MyWeatherError
    }
}
