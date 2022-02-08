//
//  UserDefaultsWrapper.swift
//  MyWeather
//
//  Created by Muthama Kahohi on 08/02/2022.
//

import Foundation

class UserDefaultsWrapper {
    
    static let shared = UserDefaultsWrapper()
    private let localDefaults = UserDefaults.standard
    
    func set(_ value: Any?, forKey defaultName: LocalDefaults) {
        localDefaults.set(value, forKey: defaultName.rawValue)
    }

    func array(forKey key: LocalDefaults) -> [String] {
        guard let array = localDefaults.stringArray(forKey: key.rawValue) else { return [] }
        return array
    }
}

enum LocalDefaults: String {

    case favoriteCities
}


