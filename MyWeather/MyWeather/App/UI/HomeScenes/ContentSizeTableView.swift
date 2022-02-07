//
//  ContentSizeTableView.swift
//  MyWeather
//
//  Created by Muthama Kahohi on 06/02/2022.
//

import Foundation
import UIKit

class ContentSizeTableView: UITableView {
    override var contentSize: CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: contentSize.width, height: contentSize.height)
    }
}
extension UITableView {
    
    static func createTable() -> UITableView {
        
        let table = UITableView()
        
        table.translatesAutoresizingMaskIntoConstraints = false
        table.tableFooterView = UIView()
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
        
        return table
    }
}



