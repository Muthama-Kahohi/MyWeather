//
//  CurrentWeatherRequest.swift
//  MyWeather
//
//  Created by Muthama Kahohi on 07/02/2022.
//

import Foundation

struct CurrentWeatherRequest: NetworkRequest {
    
    var queryItems: [String : String]
    
    var url: String {
        return EndPoints.currentPath
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    typealias Response = CurrentWeatherDataResponse
}
