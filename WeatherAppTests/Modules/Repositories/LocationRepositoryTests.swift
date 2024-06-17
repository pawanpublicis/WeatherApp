//
//  LocationRepositoryTests.swift
//  WeatherAppTests
//
//  Created by Pawan on 17/06/24.
//

import XCTest
import Combine
import CoreLocation

@testable import WeatherApp

final class DefaultLocationRepositoryTests: XCTestCase {
	var locationRepository: DefaultLocationRepository!
	var mockLocationService: MockLocationService!
	var cancellables: Set<AnyCancellable>!

	override func setUp() {
		super.setUp()
		mockLocationService = MockLocationService(manager: MockCLLocationManager())
		locationRepository = DefaultLocationRepository(service: mockLocationService, isLocationAuthorized: mockLocationService.isLocationAuthorized)
		cancellables = []
	}

	override func tearDown() {
		locationRepository = nil
		mockLocationService = nil
		cancellables = nil
		super.tearDown()
	}

	func testFetchCurrentLocationSuccess() async throws {
		let mockLocation = CLLocation(latitude: 37.7749, longitude: -122.4194)
		mockLocationService.mockLocation = mockLocation
		mockLocationService.isLocationAuthorized = true

		let location = try await locationRepository.fetchCurrentLocation()

		XCTAssertEqual(location.latitude, mockLocation.coordinate.latitude)
		XCTAssertEqual(location.longitude, mockLocation.coordinate.longitude)
	}

	func testFetchCurrentLocationFailure() async {
		mockLocationService.mockError = LocationError.authorizationDenied

		do {
			let _ = try await locationRepository.fetchCurrentLocation()
			XCTFail("Expected fetchCurrentLocation to throw, but it did not")
		} catch {
			XCTAssertEqual(error as? LocationError, LocationError.authorizationDenied)
		}
	}

	func testAuthorizationStatusFuture() {
		let expectation = self.expectation(description: "Authorization status future completes")

		locationRepository.authorizationStatusFuture()
			.sink { isAuthorized in
				XCTAssertEqual(isAuthorized, self.mockLocationService.isLocationAuthorized)
				expectation.fulfill()
			}
			.store(in: &cancellables)

		mockLocationService.isLocationAuthorized = true

		waitForExpectations(timeout: 1, handler: nil)
	}
}
