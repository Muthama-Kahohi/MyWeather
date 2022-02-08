//
//  GenericAlert.swift
//  MyWeather
//
//  Created by Muthama Kahohi on 08/02/2022.
//

import Foundation
import UIKit

class GenericAlert: UIView {
    
    // MARK: - Properties
    
    let descriptionLabel = UILabel.createLabel(title: "",
                                              textColor: .white,
                                              font: .systemFont(ofSize: 15,
                                                                weight: .medium),
                                              textAlignment: .center,
                                                    breakMode: .byWordWrapping)

    let cancelButton = UIButton.createButton(title: "cancel_title".localized(),
                                                  bgColor: .systemRed,
                                                  titleColor: .white)
    
    let doneButton = UIButton.createButton(title: "",
                                                  bgColor: .systemGreen,
                                                  titleColor: .white)
    
    let buttonsStackView = UIStackView.createStackView(alignment: .fill, distribution: .fillEqually, spacing: 5, axis: .horizontal)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    fileprivate func setupView() {

        layer.cornerRadius = 8
        backgroundColor = .black
        
        [descriptionLabel, buttonsStackView].forEach {
            addSubview($0)
        }
        
        [cancelButton, doneButton].forEach {
            buttonsStackView.addArrangedSubview($0)
        }
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            buttonsStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            buttonsStackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 40),
            buttonsStackView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            buttonsStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
    }
}

