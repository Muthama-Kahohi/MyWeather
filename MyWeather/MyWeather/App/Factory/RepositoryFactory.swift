//
//  RepositoryFactory.swift
//  MyWeather
//
//  Created by Muthama Kahohi on 06/02/2022.
//

import Foundation
class RepositoryFactory {
    
    static func weatherRepository() -> WeatherRepository {
        return WeatherRepository()
    }
}
