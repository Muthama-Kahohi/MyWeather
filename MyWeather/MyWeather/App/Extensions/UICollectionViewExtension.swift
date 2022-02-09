//
//  UICollectionViewExtension.swift
//  MyWeather
//
//  Created by Muthama Kahohi on 06/02/2022.
//

import Foundation
import UIKit

extension UICollectionView {
    
    static func createCollectionView(parent: UIView, scrollDirection: UICollectionView.ScrollDirection) -> UICollectionView {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = scrollDirection
        
        let collectionView = UICollectionView(frame: parent.frame, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }
}
