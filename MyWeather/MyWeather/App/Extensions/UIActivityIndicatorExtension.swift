//
//  UIActivityIndicatorExtension.swift
//  MyWeather
//
//  Created by Muthama Kahohi on 08/02/2022.
//

import Foundation
import UIKit

extension UIActivityIndicatorView {
    
    static func createActivityIndicator(style: UIActivityIndicatorView.Style) -> UIView {
        let view = UIView.createView()
        let spinner = UIActivityIndicatorView(style: style)
        
        view.addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        spinner.startAnimating()
        
        return view
    }
}
