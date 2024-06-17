//
//  LocationUseCaseTests.swift
//  WeatherAppTests
//
//  Created by Pawan on 17/06/24.
//

import XCTest
import Combine

@testable import WeatherApp

final class LocationUseCaseTests: XCTestCase {
	var locationUseCase: LocationUseCase!
	var mockLocationRepository: MockLocationRepository!
	var cancellables: Set<AnyCancellable>!

	override func setUp() {
		super.setUp()
		mockLocationRepository = MockLocationRepository()
		locationUseCase = LocationUseCase(repository: mockLocationRepository)
		cancellables = []
	}

	override func tearDown() {
		locationUseCase = nil
		mockLocationRepository = nil
		cancellables = nil
		super.tearDown()
	}

	func testFetchCurrentLocationSuccess() async throws {
		let mockLocation = Location(latitude: 37.7749, longitude: -122.4194)
		mockLocationRepository.mockLocation = mockLocation

		let location = try await locationUseCase.fetchCurrentLocation()

		XCTAssertEqual(location.latitude, mockLocation.latitude)
		XCTAssertEqual(location.longitude, mockLocation.longitude)
	}

	func testFetchCurrentLocationFailure() async {
		mockLocationRepository.mockError = LocationError.authorizationDenied

		do {
			let _ = try await locationUseCase.fetchCurrentLocation()
			XCTFail("Expected fetchCurrentLocation to throw, but it did not")
		} catch {
			XCTAssertEqual(error as? LocationError, LocationError.authorizationDenied)
		}
	}

	func testIsLocationAuthorized() {
		mockLocationRepository.isLocationAuthorized = true
		XCTAssertTrue(locationUseCase.isLocationAuthorized)

		mockLocationRepository.isLocationAuthorized = false
		XCTAssertFalse(locationUseCase.isLocationAuthorized)
	}

	func testAuthorizationStatusFuture() {
		let expectation = self.expectation(description: "Authorization status future completes")

		locationUseCase.authorizationStatusFuture()
			.sink { isAuthorized in
				XCTAssertEqual(isAuthorized, self.mockLocationRepository.isLocationAuthorized)
				expectation.fulfill()
			}
			.store(in: &cancellables)

		mockLocationRepository.isLocationAuthorized = true

		waitForExpectations(timeout: 1, handler: nil)
	}
}
