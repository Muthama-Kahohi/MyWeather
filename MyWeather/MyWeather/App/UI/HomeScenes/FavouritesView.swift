//
//  FavouritesView.swift
//  MyWeather
//
//  Created by Muthama Kahohi on 08/02/2022.
//

import Foundation
import UIKit

protocol FavoritesViewDelegate: AnyObject {
    func favoriteCitySelected(city: String)
}

class FavouritesView: UIView{
    
    // MARK: - Properties
    var viewModel: FavoritesViewModel?
    weak var delegate: FavoritesViewDelegate?
    
    let title = UILabel.createLabel(title: "favorite_cities".localized(),
                                    textColor: .white,
                                    font: .systemFont(ofSize: 20,
                                                      weight: .bold),
                                    textAlignment: .center,
                                    breakMode: .byWordWrapping)
    let separator = UIView.horizontalSeparator()
    let cancelButton = UIButton.createImageButton(imageName: "xmark")
    
    let doneButton = UIButton.createButton(title: "",
                                                  bgColor: .systemGreen,
                                                  titleColor: .white)
    
    let tableStackView = UIStackView.createStackView(alignment: .fill, distribution: .fillEqually, spacing: 5, axis: .vertical)
    let favoritesTable = ContentSizeTableView.createTable()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    fileprivate func setupView() {

        backgroundColor = .black
        translatesAutoresizingMaskIntoConstraints = false
        cancelButton.tintColor = .white
        favoritesTable.backgroundColor = .black
        
        [title, cancelButton, separator, tableStackView].forEach {
            addSubview($0)
        }
        
        [favoritesTable].forEach {
            tableStackView.addArrangedSubview($0)
        }
        
        favoritesTable.register(FavoritesTableViewCell.self,
                               forCellReuseIdentifier: FavoritesTableViewCell.identifier)
        favoritesTable.delegate = self
        favoritesTable.dataSource = self
        favoritesTable.separatorStyle = .singleLine
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            title.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            cancelButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            cancelButton.centerYAnchor.constraint(equalTo: title.centerYAnchor),
            
            separator.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 5),
            separator.widthAnchor.constraint(equalTo: widthAnchor),
            separator.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            tableStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            tableStackView.widthAnchor.constraint(equalTo: widthAnchor),
            tableStackView.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 10),
            tableStackView.heightAnchor.constraint(equalToConstant: 100),
            tableStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
}

extension FavouritesView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.favorites.count ?? 0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView
                .dequeueReusableCell(withIdentifier: FavoritesTableViewCell.identifier) as? FavoritesTableViewCell,
              let model = viewModel
        else { return UITableViewCell() }
        
        cell.configureCell(cityLabelText: model.favorites[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.favoriteCitySelected(city: viewModel?.favorites[indexPath.row] ?? "")
    }
}
