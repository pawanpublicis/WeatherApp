//
//  MockCLLocationManager.swift
//  WeatherAppTests
//
//  Created by Pawan on 02/06/24.
//

import Foundation
import CoreLocation
import Combine

@testable import WeatherApp

class MockLocationManager: NSObject, LocationServiceProtocol {
	var mockLocation: CLLocation?
	var mockDelegate: CLLocationManagerDelegate?

	var isLocationAuthorized: Bool = false

	func requestLocation() {
		if let location = mockLocation {
			mockDelegate?.locationManager?(CLLocationManager(), didUpdateLocations: [location])
		} else {
			mockDelegate?.locationManager?(CLLocationManager(), didFailWithError: NSError(
				domain: "LocationError",
				code: 1,
				userInfo: nil
			))
		}
	}

	func fetchCurrentLocation() async throws -> Location {
		guard isLocationAuthorized else {
			throw LocationError.authorizationDenied
		}

		if let location = mockLocation {
			return Location(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
		} else {
			throw LocationError.locationFailure(NSError(
				domain: "LocationError",
				code: 1,
				userInfo: nil
			))
		}
	}

	func authorizationStatusFuture() -> Future<Bool, Never> {
		return Future { promise in
			promise(.success(self.isLocationAuthorized))
		}
	}
}

