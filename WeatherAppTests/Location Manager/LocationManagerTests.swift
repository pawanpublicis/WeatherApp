//
//  LocationManagerTests.swift
//  WeatherAppTests
//
//  Created by Pawan on 02/06/24.
//

import XCTest
import CoreLocation
@testable import WeatherApp

class LocationManagerTests: XCTestCase {

	var locationManager: LocationManager!
	var mockLocationManager: MockCLLocationManager!

	override func setUp() {
		super.setUp()
		mockLocationManager = MockCLLocationManager()
		locationManager = LocationManager(manager: mockLocationManager)
	}

	override func tearDown() {
		locationManager = nil
		mockLocationManager = nil
		super.tearDown()
	}

	func testRequestWhenInUseAuthorization() {
		mockLocationManager.mockAuthorizationStatus = .authorizedWhenInUse
		locationManager.checkAuthorizationStatus()
		XCTAssertTrue(locationManager.isAuthorized)
	}

	func testLocationUpdateSuccess() {
		let expectedLocation = CLLocation(latitude: 37.7749, longitude: -122.4194)
		mockLocationManager.mockLocation = expectedLocation
		locationManager.requestLocation()
		
		mockLocationManager.mockDelegate?.locationManager?(mockLocationManager, didUpdateLocations: [expectedLocation])
		
		XCTAssertEqual(locationManager.location?.latitude, expectedLocation.coordinate.latitude)
		XCTAssertEqual(locationManager.location?.longitude, expectedLocation.coordinate.longitude)
		XCTAssertFalse(locationManager.isLoading)
	}

	func testLocationUpdateFailure() {
		mockLocationManager.mockLocation = nil
		locationManager.requestLocation()
		//
		mockLocationManager.delegate?.locationManager?(
			mockLocationManager,
			didFailWithError: NSError(
				domain: "LocationError",
				code: 1,
				userInfo: nil
			)
		)
		
		XCTAssertNil(locationManager.location)
		XCTAssertFalse(locationManager.isLoading)
	}

	func testAuthorizationChange() {
		mockLocationManager.mockAuthorizationStatus = .notDetermined
		locationManager.checkAuthorizationStatus()
		//
		mockLocationManager.mockAuthorizationStatus = .authorizedWhenInUse
		mockLocationManager.delegate?.locationManagerDidChangeAuthorization?(mockLocationManager)
		
		XCTAssertTrue(locationManager.isAuthorized)
	}
}
