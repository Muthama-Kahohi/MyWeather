//
//  UIStringExtension.swift
//  MyWeather
//
//  Created by Muthama Kahohi on 06/02/2022.
//

import Foundation

extension String {
    
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
    
    func convertDateFormat(fromDateFormat: DateFormat, toDateFormat: DateFormat) -> String{
        let fromdateFormatter = DateFormatter()
        fromdateFormatter.dateFormat = fromDateFormat.rawValue
        
        let todateFormatter = DateFormatter()
        todateFormatter.dateFormat = toDateFormat.rawValue
        
        let date = fromdateFormatter.date(from: self)
        
        return todateFormatter.string(from: date ?? Date())
    }
}
