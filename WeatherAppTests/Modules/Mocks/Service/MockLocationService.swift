//
//  MockLocationService.swift
//  WeatherAppTests
//
//  Created by Pawan on 17/06/24.
//

import Foundation
import CoreLocation
import Combine

@testable import WeatherApp

class MockLocationService: NSObject, LocationServiceProtocol {
	/// The CLLocationManager instance responsible for fetching the location.
	var manager: CLLocationManager
	var mockLocation: CLLocation?
	var delegate: CLLocationManagerDelegate?
	var isLocationAuthorized: Bool = false
	var mockError: Error?
	
	init(manager: CLLocationManager) {
		self.manager = manager
	}
	
	func requestLocation() {
		if let location = mockLocation {
			delegate?.locationManager?(manager, didUpdateLocations: [location])
		} else {
			delegate?.locationManager?(manager, didFailWithError: NSError(
				domain: "LocationError",
				code: 1,
				userInfo: nil
			))
		}
	}
	
	func fetchCurrentLocation() async throws -> Location {
		if let mockError {
			throw mockError
		} else {
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
	}
	
	func authorizationStatusFuture() -> Future<Bool, Never> {
		return Future { promise in
			promise(.success(self.isLocationAuthorized))
		}
	}
}
