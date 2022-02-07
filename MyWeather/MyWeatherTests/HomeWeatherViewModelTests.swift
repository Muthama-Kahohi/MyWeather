//
//  HomeWeatherViewModelTests.swift
//  MyWeatherTests
//
//  Created by Muthama Kahohi on 07/02/2022.
//

import XCTest
@testable import MyWeather

class HomeWeatherViewModelTests: XCTestCase {

    var sut: HomeWeatherViewModel!
    
    override func setUp() {
        super.setUp()
        sut = HomeWeatherViewModel(repository: WeatherRepository())
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testExample() {
        
    }
}

