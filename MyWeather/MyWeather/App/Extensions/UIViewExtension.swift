//
//  UIViewExtension.swift
//  MyWeather
//
//  Created by Muthama Kahohi on 06/02/2022.
//

import Foundation
import UIKit

extension UIView {
    
    static func createView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }
    
    static func horizontalSeparator() -> UIView {
        let view = UIView.createView()
        view.backgroundColor = .white
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true        
        return view
    }
}


