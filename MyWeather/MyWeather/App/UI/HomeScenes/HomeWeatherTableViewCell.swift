//
//  HomeWeatherTableViewCell.swift
//  MyWeather
//
//  Created by Muthama Kahohi on 06/02/2022.
//

import Foundation
import UIKit

class HomeWeatherTableViewCell: UITableViewCell {
    
    //MARK: Properties
    let firstLabel = UILabel.createLabel(title: "",
                                         textColor: .white,
                                         font: .systemFont(ofSize: 20,
                                                           weight: .medium),
                                         textAlignment: .center,
                                         breakMode: .byWordWrapping)
    
    let typeimage = UIImageView.createImageView(image: nil,
                                                contentMode: .scaleAspectFill)
    
    let lastLabel = UILabel.createLabel(title: "",
                                        textColor: .white,
                                        font: .systemFont(ofSize: 20,
                                                          weight: .medium),
                                        textAlignment: .center,
                                        breakMode: .byWordWrapping)
    
    
    //MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension HomeWeatherTableViewCell {
    
    // MARK: Methods
    private func setupCell() {
        
        [firstLabel, typeimage, lastLabel].forEach {
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            
            firstLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            firstLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            typeimage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            typeimage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            lastLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            lastLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func configureCell(firstLabelText: String, lastLabelText: String, image: UIImage?, bgColor: UIColor) {
        firstLabel.text = firstLabelText
        lastLabel.text = lastLabelText
        typeimage.image = image
        backgroundColor = bgColor
    }
}
