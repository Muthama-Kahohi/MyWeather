//
//  FavoritesTableViewCell.swift
//  MyWeather
//
//  Created by Muthama Kahohi on 08/02/2022.
//

import Foundation
import UIKit

class FavoritesTableViewCell: UITableViewCell {
    
    //MARK: Properties
    let cityLabel = UILabel.createLabel(title: "",
                                         textColor: .white,
                                         font: .systemFont(ofSize: 15,
                                                           weight: .medium),
                                         textAlignment: .center,
                                         breakMode: .byWordWrapping)
    
    
    //MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .default
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension FavoritesTableViewCell {
    
    // MARK: Methods
    private func setupCell() {
        
        backgroundColor = .black
        
        [cityLabel].forEach {
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            
            cityLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            cityLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    func configureCell(cityLabelText: String) {
        cityLabel.text = cityLabelText.capitalized
    }
}

