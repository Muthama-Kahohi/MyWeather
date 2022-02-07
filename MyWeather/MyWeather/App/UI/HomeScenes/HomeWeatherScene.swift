//
//  HomeWeatherScene.swift
//  MyWeather
//
//  Created by Muthama Kahohi on 06/02/2022.
//

import UIKit
import CoreLocation

class HomeWeatherScene: UIViewController {
    
    let parentScrollView = UIScrollView.containerScrollView()
    let topView = HomeWeatherImageView(frame: .zero)
    let separator = UIView.horizontalSeparator()
    let forecastTable = ContentSizeTableView.createTable()
    let collectionParent = UIView.createView()
    
    lazy var currentDataCollectionView = UICollectionView
        .createCollectionView(parent: self.collectionParent,
                              scrollDirection: .horizontal)
    
    let viewModel: HomeWeatherViewModel = HomeWeatherViewModel(repository: RepositoryFactory.weatherRepository())
    
    private var locationManager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScene()
    }
}

extension HomeWeatherScene {
    
    //MARK: UI Set up
    private func setupScene() {
        configureUI()
        ConfigureTableView()
        configureCollectionView()
        self.bindViewModel()
        //requestLocationAuthorization()
        //checkLocationAuthorizationOnLoad()
    }
    
    private func bindViewModel() {
        
        self.viewModel.fetchCurrentWeatherData(longitude: "139", latitude:"35") { [weak self] result in
            
            switch result {
            case .success(let bannerModel):
                DispatchQueue.main.async {
                    guard let scene = self else { return }
                    scene.topView.configureView(image: bannerModel.image,
                                                topLabelText: bannerModel.temperature,
                                                bottomLabelText: bannerModel.main)
                    
                    [scene.parentScrollView, scene.currentDataCollectionView,
                     scene.view, scene.forecastTable].forEach {
                        $0.backgroundColor = bannerModel.bgColor
                    }
                    scene.currentDataCollectionView.reloadData()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showErrorAlert(with: error.localizedDescription)
                }
            }
        }
        
        self.viewModel.fetchWeatherForecast(longitude: "139", latitude:"35") {[weak self] result in
            
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self?.forecastTable.reloadData()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showErrorAlert(with: error.localizedDescription)
                }
            }
        }
    }
    
    private func configureUI() {
        
        view.addSubview(parentScrollView)
        
        [topView, collectionParent, separator, forecastTable].forEach {
            parentScrollView.addSubview($0)
        }
        
        collectionParent.addSubview(currentDataCollectionView)
        
        NSLayoutConstraint.activate([
            parentScrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            parentScrollView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            parentScrollView.heightAnchor.constraint(equalTo: view.heightAnchor),
            parentScrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            topView.topAnchor.constraint(equalTo: parentScrollView.topAnchor),
            topView.centerXAnchor.constraint(equalTo: parentScrollView.centerXAnchor),
            topView.widthAnchor.constraint(equalTo: parentScrollView.widthAnchor),
            topView.heightAnchor.constraint(equalTo: parentScrollView.heightAnchor, multiplier: 0.5),
            
            collectionParent.topAnchor.constraint(equalTo: topView.bottomAnchor),
            collectionParent.widthAnchor.constraint(equalTo: parentScrollView.widthAnchor),
            collectionParent.centerXAnchor.constraint(equalTo: parentScrollView.centerXAnchor),
            collectionParent.heightAnchor.constraint(equalToConstant: 50),
            
            currentDataCollectionView.centerXAnchor.constraint(equalTo: collectionParent.centerXAnchor),
            currentDataCollectionView.centerYAnchor.constraint(equalTo: collectionParent.centerYAnchor),
            currentDataCollectionView.heightAnchor.constraint(equalTo: collectionParent.heightAnchor),
            currentDataCollectionView.widthAnchor.constraint(equalTo: collectionParent.widthAnchor),
            
            separator.topAnchor.constraint(equalTo: collectionParent.bottomAnchor, constant: 5),
            separator.widthAnchor.constraint(equalTo: parentScrollView.widthAnchor),
            separator.centerXAnchor.constraint(equalTo: parentScrollView.centerXAnchor),
        
            forecastTable.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 10),
            forecastTable.widthAnchor.constraint(equalTo: parentScrollView.widthAnchor),
            forecastTable.centerXAnchor.constraint(equalTo: parentScrollView.centerXAnchor),
            forecastTable.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func ConfigureTableView() {
        forecastTable.delegate = self
        forecastTable.dataSource = self
        
        forecastTable.register(HomeWeatherTableViewCell.self,
                               forCellReuseIdentifier: HomeWeatherTableViewCell.identifier)
    }
    
    private func configureCollectionView() {
        
        currentDataCollectionView.delegate = self
        currentDataCollectionView.dataSource = self
        
        currentDataCollectionView.register(HomeWeatherCollectionViewCell.self,
                                           forCellWithReuseIdentifier: HomeWeatherCollectionViewCell.identifier)
        
    }
    
    private func requestLocationAuthorization() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
    }
    
    private func requestAuthorizationAlert() {
        let alertController = UIAlertController(title: "location_permission_request_title".localized(),
                                                message: "",
                                                preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "settings_title".localized(),
                                            style: .default) {[weak self] _ in
            self?.presentLocationSettings()
        }
        
        let cancelAction = UIAlertAction(title: "cancel_title".localized(),
                                            style: .default) {[weak self] _ in
            print("Cancelled")
        }
        
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController,
                     animated: true,
                     completion: nil)
    }
    
    private func presentLocationSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: nil)
        }
    }
    
    private func checkLocationAuthorizationOnLoad(){
        
        switch(CLLocationManager.authorizationStatus()) {
        case .notDetermined, .restricted, .denied:
            requestAuthorizationAlert()
        case .authorizedAlways, .authorizedWhenInUse:
            self.bindViewModel()
        @unknown default:
            requestAuthorizationAlert()
        }
    }
    
    private func showErrorAlert(with message: String) {
        let alertController = UIAlertController(title: "error_title".localized(),
                                                message: message,
                                                preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "done_title".localized(),
                                            style: .default) {[weak self] _ in
            print("Cancelled")
        }
        
        let tryAgainAction = UIAlertAction(title: "try_again_title".localized(),
                                     style: .default) {[weak self] _ in
            self?.bindViewModel() }
 
        
        alertController.addAction(okAction)
        alertController.addAction(tryAgainAction)
        
        self.present(alertController,
                     animated: true,
                     completion: nil)
    }
    
}

extension HomeWeatherScene: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.forecastCellModels.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeWeatherTableViewCell.identifier) as? HomeWeatherTableViewCell else { return UITableViewCell() }
        
        let model = viewModel.forecastCellModels[indexPath.row]
        cell.configureCell(firstLabelText: model.firstText,
                           lastLabelText: model.lastText,
                           image: model.icon)
        return cell
    }
}

extension HomeWeatherScene: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.cellModels.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
        
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: HomeWeatherCollectionViewCell.identifier,
                                     for: indexPath) as? HomeWeatherCollectionViewCell else {
                    return UICollectionViewCell()
                }
        
        let model = viewModel.cellModels[indexPath.row]
        cell.configureCell(topLabelText: model.topText,
                           bottomLabelText: model.bottomText,
                           bgColor: model.bgColor)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width / 3), height: collectionView.bounds.height )
    }
}

extension HomeWeatherScene: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {}
            }
            
            self.bindViewModel()
        case .restricted, .denied, .notDetermined:
            requestAuthorizationAlert()
        @unknown default:
            requestAuthorizationAlert()
        }
    }
}
