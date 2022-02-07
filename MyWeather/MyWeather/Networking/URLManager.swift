//
//  URLManager.swift
//  MyWeather
//
//  Created by Muthama Kahohi on 06/02/2022.
//

import Foundation

enum URLManager {
    case current
    case forecast
}

extension URLManager {
    
    var path: String {
        switch self {
            
        case .current:
            return EndPoints.currentPath
        case .forecast:
            return EndPoints.forecastPath
        }
    }
}

