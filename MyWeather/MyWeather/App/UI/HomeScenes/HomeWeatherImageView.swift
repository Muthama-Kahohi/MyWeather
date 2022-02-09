//
//  HomeWeatherImageView.swift
//  MyWeather
//
//  Created by Muthama Kahohi on 06/02/2022.
//

import UIKit

class HomeWeatherImageView: UIView {
    
    // MARK: Properties
    let topLabel = UILabel.createLabel(title: "",
                                       textColor: .white,
                                       font: .systemFont(ofSize: 50,
                                                         weight: .medium),
                                       textAlignment: .center,
                                       breakMode: .byWordWrapping)
    
    let bottomLabel = UILabel.createLabel(title: "",
                                          textColor: .white,
                                          font: .systemFont(ofSize: 25,
                                                            weight: .medium),
                                          textAlignment: .center,
                                          breakMode: .byWordWrapping)
    
    let weatherImageView = UIImageView.createImageView(image: nil,
                                                       contentMode: .scaleAspectFit)
    
    //MARK:- Initializer
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
}

extension HomeWeatherImageView {
    
    // MARK: Methods
    private func setupView() {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        [weatherImageView, topLabel, bottomLabel].forEach {
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            weatherImageView.topAnchor.constraint(equalTo: topAnchor),
            weatherImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            weatherImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            weatherImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            topLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            topLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            bottomLabel.topAnchor.constraint(equalTo: topLabel.bottomAnchor,
                                             constant: 10),
            bottomLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
    
    func configureView(image: UIImage?, topLabelText: String, bottomLabelText: String) {
        weatherImageView.image = image
        bottomLabel.text = bottomLabelText
        topLabel.text = topLabelText
    }
}
