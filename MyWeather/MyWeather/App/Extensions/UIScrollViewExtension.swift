//
//  UIScrollViewExtension.swift
//  MyWeather
//
//  Created by Muthama Kahohi on 06/02/2022.
//

import Foundation
import UIKit

extension UIScrollView {
    
    static func containerScrollView() -> UIScrollView {
        let scrollView = UIScrollView()
        
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.isScrollEnabled = true
        
        return scrollView
    }
}
