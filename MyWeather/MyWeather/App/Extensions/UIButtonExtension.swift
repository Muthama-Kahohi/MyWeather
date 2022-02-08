//
//  UIButtonExtension.swift
//  MyWeather
//
//  Created by Muthama Kahohi on 08/02/2022.
//

import Foundation
import UIKit

extension UIButton {
    
    static func createButton(title: String, bgColor: UIColor, titleColor: UIColor, height: CGFloat = 40) -> UIButton {
        
        let button = UIButton()
        
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.backgroundColor = bgColor
        button.layer.cornerRadius = height / 2
        button.heightAnchor.constraint(equalToConstant: height).isActive = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    static func createImageButton(imageName: String, borderColor: UIColor = .clear) -> UIButton {
        
        let button = UIButton()
        button.setImage(UIImage(systemName: imageName), for: .normal)
        button.layer.borderColor = borderColor.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }
}
