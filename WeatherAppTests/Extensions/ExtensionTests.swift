//
//  ExtensionTests.swift
//  WeatherAppTests
//
//  Created by Pawan on 12/06/24.
//

import XCTest
import CoreLocation

@testable import WeatherApp

class ExtensionsTests: XCTestCase {
	//
	func testRoundDouble() {
		let value: Double = 23.567
		XCTAssertEqual(value.roundDouble(), "24")
	}

	func testDegree() {
		let value: Double = 23.567
		XCTAssertEqual(value.degree(), "24°")
	}

	func testMs() {
		let value: Double = 5.789
		XCTAssertEqual(value.ms(), "6 m/s")
	}
	
	func testLocationCoordinatetEquatable() {
		let coord1 = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
		let coord2 = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
		let coord3 = CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060)
		
		XCTAssertEqual(coord1, coord2)
		XCTAssertNotEqual(coord1, coord3)
	}
	
	func testGetWeatherIcon() {
		XCTAssertEqual(getWeatherIcon(condition: 200), "🌩")
		XCTAssertEqual(getWeatherIcon(condition: 301), "🌧")
		XCTAssertEqual(getWeatherIcon(condition: 501), "☔️")
		XCTAssertEqual(getWeatherIcon(condition: 601), "☃️")
		XCTAssertEqual(getWeatherIcon(condition: 701), "🌫")
		XCTAssertEqual(getWeatherIcon(condition: 800), "☀️")
		XCTAssertEqual(getWeatherIcon(condition: 802), "☁️")
		XCTAssertEqual(getWeatherIcon(condition: 900), "🤷‍")
	}
}
