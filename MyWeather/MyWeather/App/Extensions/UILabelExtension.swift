//
//  UILabelExtension.swift
//  MyWeather
//
//  Created by Muthama Kahohi on 06/02/2022.
//

import UIKit

extension UILabel {
    
    static func createLabel(title: String,
                            textColor: UIColor,
                            font: UIFont,
                            textAlignment: NSTextAlignment,
                            breakMode: NSLineBreakMode) -> UILabel {
        
        let label = UILabel()
        label.text = title
        label.textColor = textColor
        label.font = font
        label.textAlignment = textAlignment
        label.lineBreakMode = breakMode
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }
}
