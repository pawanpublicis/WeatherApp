//
//  LocationServiceTests.swift
//  WeatherAppTests
//
//  Created by Pawan on 17/06/24.
//

import XCTest
import Combine
import CoreLocation

@testable import WeatherApp

final class LocationServiceTests: XCTestCase {
	var locationService: LocationService!
	var mockLocationManager: MockCLLocationManager!
	var cancellables: Set<AnyCancellable>!

	override func setUp() {
		super.setUp()
		mockLocationManager = MockCLLocationManager()
		locationService = LocationService(manager: mockLocationManager)
		cancellables = []
	}

	override func tearDown() {
		locationService = nil
		mockLocationManager = nil
		cancellables = nil
		super.tearDown()
	}

	func testAuthorizationStatus() {
		let expectation = self.expectation(description: "Authorization status changes")

		locationService.authorizationStatusFuture()
			.sink { isAuthorized in
				XCTAssertTrue(isAuthorized)
				expectation.fulfill()
			}
			.store(in: &cancellables)

		mockLocationManager.requestWhenInUseAuthorization()

		waitForExpectations(timeout: 1, handler: nil)
	}

	func testFetchCurrentLocationSuccess() async throws {
		let mockLocation = CLLocation(latitude: 37.7749, longitude: -122.4194)
		mockLocationManager.mockLocation = mockLocation
		mockLocationManager.mockAuthorizationStatus = .authorizedWhenInUse
		locationService.checkAuthorizationStatus()

		let location = try await locationService.fetchCurrentLocation()

		XCTAssertEqual(location.latitude, mockLocation.coordinate.latitude)
		XCTAssertEqual(location.longitude, mockLocation.coordinate.longitude)
	}

	func testFetchCurrentLocationFailure() async {
		mockLocationManager.mockError = NSError(domain: "MockError", code: -1, userInfo: nil)
		mockLocationManager.mockAuthorizationStatus = .authorizedWhenInUse
		locationService.checkAuthorizationStatus()

		do {
			_ = try await locationService.fetchCurrentLocation()
			XCTFail("Expected fetchCurrentLocation to throw, but it did not")
		} catch {
			XCTAssertNotNil(error)
		}
	}

	func testFetchCurrentLocationAuthorizationDenied() async {
		mockLocationManager.mockAuthorizationStatus = .denied
		locationService.checkAuthorizationStatus()

		do {
			_ = try await locationService.fetchCurrentLocation()
			XCTFail("Expected fetchCurrentLocation to throw, but it did not")
		} catch {
			XCTAssertEqual(error as? LocationError, LocationError.authorizationDenied)
		}
	}

	func testLocationManagerDidUpdateLocations() {
		let expectation = self.expectation(description: "Location updated")
		let mockLocation = CLLocation(latitude: 37.7749, longitude: -122.4194)
		mockLocationManager.mockLocation = mockLocation
		mockLocationManager.mockAuthorizationStatus = .authorizedWhenInUse
		locationService.checkAuthorizationStatus()

		Task {
			do {
				let location = try await locationService.fetchCurrentLocation()
				XCTAssertEqual(location.latitude, mockLocation.coordinate.latitude)
				XCTAssertEqual(location.longitude, mockLocation.coordinate.longitude)
				expectation.fulfill()
			} catch {
				XCTFail("Expected fetchCurrentLocation to succeed, but it failed")
			}
		}

		mockLocationManager.delegate?.locationManager?(mockLocationManager, didUpdateLocations: [mockLocation])

		waitForExpectations(timeout: 1, handler: nil)
	}

	func testLocationManagerDidFailWithError() {
		let expectation = self.expectation(description: "Location failed with error")
		let mockError = NSError(domain: "MockError", code: -1, userInfo: nil)
		mockLocationManager.mockError = mockError
		mockLocationManager.mockAuthorizationStatus = .authorizedWhenInUse
		locationService.checkAuthorizationStatus()

		Task {
			do {
				_ = try await locationService.fetchCurrentLocation()
				XCTFail("Expected fetchCurrentLocation to fail, but it succeeded")
			} catch {
				XCTAssertNotNil(error)
				expectation.fulfill()
			}
		}

		mockLocationManager.delegate?.locationManager?(mockLocationManager, didFailWithError: mockError)

		waitForExpectations(timeout: 1, handler: nil)
	}
}
