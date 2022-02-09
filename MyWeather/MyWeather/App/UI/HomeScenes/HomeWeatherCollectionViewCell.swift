//
//  HomeWeatherCollectionViewCell.swift
//  MyWeather
//
//  Created by Muthama Kahohi on 06/02/2022.
//

import Foundation
import UIKit

class HomeWeatherCollectionViewCell: UICollectionViewCell {
    
    //MARK: Properties
    let topLabel = UILabel.createLabel(title: "",
                                       textColor: .white,
                                       font: .systemFont(ofSize: 20,
                                                         weight: .regular),
                                       textAlignment: .center,
                                       breakMode: .byWordWrapping)
    
    let bottomLabel = UILabel.createLabel(title: "",
                                          textColor: .white,
                                          font: .systemFont(ofSize: 16,
                                                            weight: .regular),
                                          textAlignment: .center,
                                          breakMode: .byWordWrapping)
    
    //MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension HomeWeatherCollectionViewCell {
    
    private func setupCell() {
        [topLabel, bottomLabel].forEach {
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            topLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            topLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            bottomLabel.topAnchor.constraint(equalTo: topLabel.bottomAnchor,
                                             constant: 5),
            bottomLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            bottomLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        ])
    }
    
    func configureCell(topLabelText: String, bottomLabelText: String, bgColor: UIColor) {
        topLabel.text = topLabelText
        bottomLabel.text = bottomLabelText
        backgroundColor = bgColor
    }
}
