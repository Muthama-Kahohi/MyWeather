//
//  WeatherForecastRequest.swift
//  MyWeather
//
//  Created by Muthama Kahohi on 07/02/2022.
//

import Foundation

struct WeatherForecastRequest: NetworkRequest {
    var queryItems: [String : String]

    var url: String {
        return EndPoints.forecastPath
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    typealias Response = WeatherForecastResponse
}
