//
//  HomeWeatherScene.swift
//  MyWeather
//
//  Created by Muthama Kahohi on 06/02/2022.
//

import UIKit

class HomeWeatherScene: UIViewController {
    
    let parentScrollView = UIScrollView.containerScrollView()
    let topView = HomeWeatherImageView(frame: .zero)
    let separator = UIView.horizontalSeparator()
    let forecastTable = ContentSizeTableView.createTable()
    let collectionParent = UIView.createView()
    
    lazy var currentDataCollectionView: UICollectionView  = {
        
        return UICollectionView.createCollectionView(parent: self.collectionParent, scrollDirection: .horizontal)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension HomeWeatherScene {
    
    //MARK: UI Set up
    
    private func setupScene() {
        configureUI()
    }
    
    private func configureUI() {
        
        view.addSubview(parentScrollView)
        
        [topView, separator, forecastTable, collectionParent].forEach {
            parentScrollView.addSubview($0)
        }
        collectionParent.addSubview(currentDataCollectionView)
        
        NSLayoutConstraint.activate([
            parentScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            parentScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            parentScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            parentScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            topView.topAnchor.constraint(equalTo: parentScrollView.topAnchor),
            topView.leadingAnchor.constraint(equalTo: parentScrollView.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: parentScrollView.trailingAnchor),
            topView.heightAnchor.constraint(equalTo: parentScrollView.heightAnchor, multiplier: 0.4),
            
            collectionParent.topAnchor.constraint(equalTo: topView.bottomAnchor),
            collectionParent.leadingAnchor.constraint(equalTo: parentScrollView.leadingAnchor),
            collectionParent.trailingAnchor.constraint(equalTo: parentScrollView.trailingAnchor),
            collectionParent.heightAnchor.constraint(equalToConstant: 50),
            
            separator.topAnchor.constraint(equalTo: collectionParent.bottomAnchor),
            separator.leadingAnchor.constraint(equalTo: parentScrollView.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: parentScrollView.trailingAnchor),
            
            forecastTable.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 10),
            forecastTable.leadingAnchor.constraint(equalTo: parentScrollView.leadingAnchor),
            forecastTable.trailingAnchor.constraint(equalTo: parentScrollView.trailingAnchor)
        ])
    }
    
    private func ConfigureTableView() {
        forecastTable.delegate = self
        forecastTable.dataSource = self
    }
    
    private func configureCollectionView() {
        
        currentDataCollectionView.delegate = self
        currentDataCollectionView.dataSource = self
    }
}

extension HomeWeatherScene: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension HomeWeatherScene: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}


