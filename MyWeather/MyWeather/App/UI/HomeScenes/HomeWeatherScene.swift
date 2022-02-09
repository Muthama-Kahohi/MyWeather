//
//  HomeWeatherScene.swift
//  MyWeather
//
//  Created by Muthama Kahohi on 06/02/2022.
//

import UIKit
import CoreLocation

class HomeWeatherScene: UIViewController {
    
    let viewModel: HomeWeatherViewModel = HomeWeatherViewModel(repository: RepositoryFactory.weatherRepository())
    
    let parentScrollView = UIScrollView.containerScrollView()
    let topView = HomeWeatherImageView(frame: .zero)
    let separator = UIView.horizontalSeparator()
    let forecastTable = ContentSizeTableView.createTable()
    let collectionParent = UIView.createView()
    let searchBar = UISearchBar.createSearchBar()
    let byLocationButton = UIButton.createButton(title: "by_location_button_title".localized(), bgColor: .systemRed, titleColor: .white)
    let myLocationButton = UIButton.createButton(title: "my_location_button_title".localized(), bgColor: .systemGreen, titleColor: .white)
    let saveButton = UIButton.createButton(title: "save_title".localized(), bgColor: .systemBlue, titleColor: .white)
    let spinner = UIActivityIndicatorView.createActivityIndicator(style: .large)
    let buttonsStackView = UIStackView.createStackView(alignment: .fill, distribution: .fillEqually, spacing: 5, axis: .horizontal)
    let viewFavouritesButton = UIButton.createImageButton(imageName: "text.justify")
    let cityLabel = UILabel.createLabel(title: "", textColor: .white,
                                        font: .systemFont(ofSize: 20,
                                                          weight: .medium),
                                        textAlignment: .right,
                                        breakMode: .byWordWrapping)

    lazy var currentDataCollectionView = UICollectionView
        .createCollectionView(parent: self.collectionParent,
                              scrollDirection: .horizontal)
    
    lazy var favouritesView: FavouritesView = {
        let view = FavouritesView(frame: .zero)
        let model = ViewModelFactory.favorites()
        model.favorites = self.viewModel.fetchFavouriteCities()
        view.viewModel = model
        view.delegate = self
        return view
    }()
    
    private var locationManager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScene()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestLocationAuthorization()
    }
}

extension HomeWeatherScene {
    
    //MARK: UI Set up
    private func setupScene() {
        configureUI()
        ConfigureTableView()
        configureCollectionView()
        configureSearchBar()
    }
    
    @objc private func fetchWeatherData() {
        startAnimating()
        self.dismissAlert()
        self.viewModel.fetchCurrentWeatherData() { [weak self] result in
            self?.stopAnimating()
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
                    if scene.viewModel.weatherSearch == .otherLocation {
                        scene.saveCity()
                        scene.cityLabel.text = scene.viewModel.city
                    } else {
                        scene.saveButton.isHidden = true
                        scene.cityLabel.text = ""
                    }
                    scene.cityLabel.isHidden = scene.viewModel.weatherSearch == .myLocation
                    scene.buttonsStackView.isHidden = false
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showErrorAlert(with: error.localizedDescription)
                }
            }
        }
        
        self.viewModel.fetchWeatherForecast() {[weak self] result in
            self?.stopAnimating()
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
        
        [parentScrollView, searchBar, favouritesView, viewFavouritesButton, cityLabel].forEach {
            view.addSubview($0)
        }

        [topView, collectionParent,
         separator, forecastTable, buttonsStackView,
         spinner].forEach {
            parentScrollView.addSubview($0)
        }
        
        [byLocationButton, myLocationButton, saveButton].forEach {
            buttonsStackView.addArrangedSubview($0)
        }
        
        collectionParent.addSubview(currentDataCollectionView)
        
        byLocationButton.addTarget(self, action: #selector(otherLocationButtonTapped), for: .touchUpInside)
        myLocationButton.addTarget(self, action: #selector(myLocationButtonTapped), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveCityAlert), for: .touchUpInside)
        
        spinner.isHidden = true
        saveButton.isHidden = true
        buttonsStackView.isHidden = true
        
        favouritesView.cancelButton.addTarget(self, action: #selector(hideFavoritesView), for: .touchUpInside)
        favouritesView.isHidden = true
        
        viewFavouritesButton.isHidden = viewModel.fetchFavouriteCities().count == 0
        viewFavouritesButton.tintColor = .white
        viewFavouritesButton.addTarget(self, action: #selector(showFavouriteCities), for: .touchUpInside)
        
        self.hideKeyboardWhenTapped()
      
        NSLayoutConstraint.activate([
            parentScrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            parentScrollView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            parentScrollView.heightAnchor.constraint(equalTo: view.heightAnchor),
            parentScrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            topView.topAnchor.constraint(equalTo: parentScrollView.topAnchor),
            topView.centerXAnchor.constraint(equalTo: parentScrollView.centerXAnchor),
            topView.widthAnchor.constraint(equalTo: parentScrollView.widthAnchor),
            topView.heightAnchor.constraint(equalTo: parentScrollView.heightAnchor, multiplier: 0.5),
            
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            searchBar.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            searchBar.heightAnchor.constraint(equalToConstant: 40),
            
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
            forecastTable.heightAnchor.constraint(equalToConstant: 200),
            
            buttonsStackView.centerXAnchor.constraint(equalTo: parentScrollView.centerXAnchor),
            buttonsStackView.widthAnchor.constraint(equalTo: parentScrollView.widthAnchor, multiplier: 0.9),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 40),
            buttonsStackView.topAnchor.constraint(equalTo: forecastTable.bottomAnchor, constant: 10),

            spinner.centerXAnchor.constraint(equalTo: parentScrollView.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: parentScrollView.centerYAnchor),
            spinner.widthAnchor.constraint(equalToConstant: 50),
            spinner.heightAnchor.constraint(equalToConstant: 50),
            
            favouritesView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            favouritesView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            favouritesView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            viewFavouritesButton.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor),
            viewFavouritesButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            viewFavouritesButton.widthAnchor.constraint(equalToConstant: 50),
            viewFavouritesButton.heightAnchor.constraint(equalToConstant: 50),
            
            cityLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cityLabel.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 5),
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
    
    private func configureSearchBar() {
        searchBar.textField?.placeholder = "enter_city_text".localized()
        searchBar.isHidden = true
        searchBar.delegate = self
    }
    
    private func requestLocationAuthorization() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
    }
        
    @objc private func presentLocationSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: nil)
        }
    }
    
    private func checkLocationAuthorizationOnLoad(){
        
        switch(CLLocationManager.authorizationStatus()) {
        case .notDetermined, .restricted, .denied:
            locationManager?.requestAlwaysAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            self.fetchWeatherData()
        @unknown default:
            locationManager?.requestAlwaysAuthorization()
        }
    }
    
    private func showErrorAlert(with message: String) {
        dismissAlert()
        var alert = GenericAlert(frame: .zero)
        alert.descriptionLabel.text =  message
        alert.cancelButton.setTitle("done_title".localized(), for: .normal)
        alert.doneButton.setTitle("try_again_title".localized(), for: .normal)
        
        alert.doneButton.addTarget(self, action: #selector(fetchWeatherData), for: .touchUpInside)
        alert.cancelButton.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
        
        self.presentAlert(alert: &alert, width: 0.9)
    }
    
    @objc private func saveCityAlert() {
        dismissAlert()
        var alert = GenericAlert(frame: .zero)
        alert.descriptionLabel.text =  String(format: "save_city_description".localized(), viewModel.city)
        alert.doneButton.setTitle("save_title".localized(), for: .normal)
        alert.doneButton.addTarget(self, action: #selector(saveFavouriteCity), for: .touchUpInside)
        alert.cancelButton.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
        self.presentAlert(alert: &alert, width: 0.9)
    }
    
    private func requestAuthorizationAlert() {
        dismissAlert()
        var alert = GenericAlert(frame: .zero)
        alert.backgroundColor = .gray
        alert.descriptionLabel.text = "location_permission_request_title".localized()
        alert.cancelButton.setTitle("cancel_title".localized(), for: .normal)
        alert.doneButton.setTitle("settings_title".localized(), for: .normal)
        
        alert.doneButton.addTarget(self, action: #selector(presentLocationSettings), for: .touchUpInside)
        alert.cancelButton.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
        
        self.presentAlert(alert: &alert, width: 1.0)
    }
    
    private func successfulFavoriteSaveAlert(message: String) {
        dismissAlert()
        var alert = GenericAlert(frame: .zero)
        alert.descriptionLabel.text = message
        alert.cancelButton.isHidden = true
        alert.doneButton.setTitle("done_title".localized(), for: .normal)
        
        alert.doneButton.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
        
        self.presentAlert(alert: &alert, width: 0.5)
    }
    
    @objc private func otherLocationButtonTapped() {
        viewModel.city = ""
        searchBar.isHidden = !searchBar.isHidden
    }
    
    @objc private func myLocationButtonTapped() {
        viewModel.weatherSearch = .myLocation
        searchBar.isHidden = true
        searchBar.textField?.resignFirstResponder()
        fetchWeatherData()
    }
    
    private func startAnimating() {
        DispatchQueue.main.async {
            self.spinner.isHidden = false
        }
    }
    
    private func stopAnimating() {
        DispatchQueue.main.async {
            self.spinner.isHidden = true
        }
    }
    
    private func saveCity() {
        DispatchQueue.main.async {
            self.saveButton.isHidden = self.viewModel.fetchFavouriteCities().contains(self.viewModel.city)
        }
    }
    
    @objc private func dismissAlert() {
        let subviews = self.view.subviews
        guard let topAlert = (subviews.filter{ $0 is GenericAlert }).first as? GenericAlert else {
            return
        }
        topAlert.removeFromSuperview()
    }
    
    @objc private func saveFavouriteCity() {
        self.viewModel.saveCity() { [weak self] message in
            self?.successfulFavoriteSaveAlert(message: message)
            self?.saveButton.isHidden = true
            self?.viewFavouritesButton.isHidden = self?.viewModel.fetchFavouriteCities().count == 0
        }
    }
    
    @objc private func hideFavoritesView() {
        favouritesView.isHidden = true
    }
    
    @objc private func showFavouriteCities() {
        favouritesView.viewModel?.favorites = viewModel.fetchFavouriteCities()
        favouritesView.favoritesTable.reloadData()
        favouritesView.isHidden = !favouritesView.isHidden
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
                           image: model.icon,
                           imageTint: .white)
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
            guard let location = manager.location else { return }
            viewModel.coordinates = Coordinates(lon: location.coordinate.longitude,
                                                lat: location.coordinate.longitude)
            self.fetchWeatherData()
        case .restricted, .denied, .notDetermined:
            self.requestAuthorizationAlert()
        @unknown default:
            self.requestAuthorizationAlert()
        }
    }
}

extension HomeWeatherScene: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
       
        guard let textField = searchBar.textField,
              let text = textField.text else { return }
        textField.resignFirstResponder()
        
        if text.isEmpty {
            return
        } else {
            viewModel.city = text
            viewModel.weatherSearch = .otherLocation
        }
       
        fetchWeatherData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.city = ""
        viewModel.weatherSearch = .myLocation
        searchBar.textField?.resignFirstResponder()
    }
}

extension HomeWeatherScene: FavoritesViewDelegate {
    func favoriteCitySelected(city: String) {
        favouritesView.isHidden = true
        viewModel.weatherSearch = .otherLocation
        viewModel.city = city
        fetchWeatherData()
    }
}
