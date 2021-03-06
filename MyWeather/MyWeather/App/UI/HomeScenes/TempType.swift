//
//  TempType.swift
//  MyWeather
//
//  Created by Muthama Kahohi on 06/02/2022.
//

import Foundation
import UIKit

enum WeatherType: String {
    case sunny
    case rainy
    case cloudy
}

extension WeatherType{
    
    var image: UIImage? {
        switch self {
        case .sunny:
            return UIImage(named: "forest_sunny")
        case .rainy:
            return UIImage(named: "forest_rainy")
        case .cloudy:
            return UIImage(named: "forest_cloudy")
        }
    }
    
    var bgColor: UIColor {
        switch self {
        case .sunny:
            return UIColor(hexString: "47AB2F")
        case .rainy:
            return UIColor(hexString: "57575D")
        case .cloudy:
            return UIColor(hexString: "54717A")
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .sunny:
            return UIImage(systemName: "sun.max")
        case .rainy:
            return UIImage(systemName: "cloud.heavyrain")
        case .cloudy:
            return UIImage(systemName: "cloud")
        }
    }
}

