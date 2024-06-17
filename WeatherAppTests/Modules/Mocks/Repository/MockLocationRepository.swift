//
//  MockLocationRepository.swift
//  WeatherAppTests
//
//  Created by Pawan on 17/06/24.
//

import Foundation
import Combine

@testable import WeatherApp

class MockLocationRepository: LocationRepository {
	//
	var mockLocation: Location?
	var mockError: Error?
	var mockAuthorizationStatus: Bool = false
	var authorizationStatusPromise: Future<Bool, Never>?
	
	var isLocationAuthorized: Bool {
		get { return mockAuthorizationStatus }
		set { mockAuthorizationStatus = newValue }
	}
	
	func fetchCurrentLocation() async throws -> Location {
		if let error = mockError {
			throw error
		}
		
		if let location = mockLocation {
			return location
		}
		
		throw NSError(domain: "MockLocationRepositoryError", code: -1, userInfo: nil)
	}
	
	func requestLocation() {
		// Implement any logic needed for testing requestLocation behavior if necessary
	}
	
	func authorizationStatusFuture() -> Future<Bool, Never> {
		if let promise = authorizationStatusPromise {
			return promise
		} else {
			return Future<Bool, Never> { promise in
				promise(.success(self.mockAuthorizationStatus))
			}
		}
	}
}
