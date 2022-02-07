//
//  MyWeatherTests.swift
//  MyWeatherTests
//
//  Created by Muthama Kahohi on 06/02/2022.
//

import XCTest
@testable import MyWeather

class NetworkManagerTests: XCTestCase {

    var sut: NetworkManager!
    
    override func setUp() {
        super.setUp()
        sut = NetworkManager()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testExample() {
        
    }
}
