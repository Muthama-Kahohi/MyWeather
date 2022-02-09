//
//  HomeWeatherSceneTests.swift
//  MyWeatherTests
//
//  Created by Muthama Kahohi on 07/02/2022.
//

import XCTest
@testable import MyWeather

class HomeWeatherSceneTests: XCTestCase {

    var sut: HomeWeatherScene!
    
    override func setUp() {
        super.setUp()
        sut = HomeWeatherScene()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_viewModel_isNotNil() {
        sut.viewDidLoad()
        XCTAssertNotNil(sut.viewModel)
    }
}
