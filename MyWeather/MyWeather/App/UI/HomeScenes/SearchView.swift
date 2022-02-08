//
//  SearchView.swift
//  MyWeather
//
//  Created by Muthama Kahohi on 08/02/2022.
//

import UIKit

extension UISearchBar {
    
    public var textField: UITextField? {
        
        if #available(iOS 13, *) { return searchTextField }
        let subviews = subviews.flatMap { $0.subviews }
        
        guard let textField = (subviews.filter{ $0 is UITextField }).first as? UITextField else {
            return nil
        }
        return textField
    }
    
    static func createSearchBar() -> UISearchBar {
        let searchBar = UISearchBar()
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.heightAnchor.constraint(equalToConstant: 40).isActive = true
        searchBar.searchBarStyle = .minimal
        searchBar.barStyle = .default
        searchBar.barTintColor = .black

        return searchBar
    }
}

