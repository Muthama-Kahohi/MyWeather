//
//  UIImageViewExtension.swift
//  MyWeather
//
//  Created by Muthama Kahohi on 06/02/2022.
//

import UIKit

extension UIImageView {
    
    static func createImageView(image: UIImage? = nil, contentMode: UIView.ContentMode) -> UIImageView {
        
        let imageView = UIImageView()
        imageView.image = image
        imageView.contentMode = contentMode
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }
}
