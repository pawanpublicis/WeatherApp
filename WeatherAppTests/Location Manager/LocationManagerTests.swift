//
//  LocationManagerTests.swift
//  WeatherAppTests
//
//  Created by Pawan on 02/06/24.
//

import XCTest
import Combine
import CoreLocation

@testable import WeatherApp

class LocationManagerTests: XCTestCase {
	var locationManager: LocationManager!
	var mockLocationManager: MockCLLocationManager!
	var cancellables: Set<AnyCancellable>!

	override func setUp() {
		super.setUp()
		mockLocationManager = MockCLLocationManager()
		locationManager = LocationManager(manager: mockLocationManager)
		cancellables = []
	}

	override func tearDown() {
		locationManager = nil
		mockLocationManager = nil
		cancellables = nil
		super.tearDown()
	}

	func testLocationUpdateSuccess() async {
		let expectedLocation = CLLocation(latitude: 37.7749, longitude: -122.4194)
		mockLocationManager.mockLocation = expectedLocation
		locationManager.isLocationAuthorized = true

		let location = try? await locationManager.fetchCurrentLocation()

		XCTAssertEqual(location?.latitude, expectedLocation.coordinate.latitude)
		XCTAssertEqual(location?.longitude, expectedLocation.coordinate.longitude)
	}

	func testLocationUpdateFailure() async {
		mockLocationManager.mockLocation = nil
		locationManager.isLocationAuthorized = true

		do {
			_ = try await locationManager.fetchCurrentLocation()
			XCTFail("Expected to throw an error but did not.")
		} catch {
			XCTAssertTrue(error is LocationError)
		}
	}

	func testAuthorizationStatus() {
		let expectation = XCTestExpectation(description: "Authorization status future should complete")

		locationManager.isLocationAuthorized = true

		locationManager.authorizationStatusFuture()
			.sink { isAuthorized in
				XCTAssertTrue(isAuthorized)
				expectation.fulfill()
			}
			.store(in: &cancellables)

		wait(for: [expectation], timeout: 1.0)
	}
}
