//
//  UIStackViewExtension.swift
//  MyWeather
//
//  Created by Muthama Kahohi on 08/02/2022.
//

import Foundation
import UIKit

extension UIStackView {
    
    static func createStackView(alignment: UIStackView.Alignment,
                                distribution: UIStackView.Distribution,
                                spacing: CGFloat, axis: NSLayoutConstraint.Axis) -> UIStackView {
        let stackView = UIStackView()
        stackView.alignment = alignment
        stackView.distribution = distribution
        stackView.spacing = spacing
        stackView.axis = axis
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }
}

