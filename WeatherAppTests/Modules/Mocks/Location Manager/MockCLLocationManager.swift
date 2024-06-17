//
//  MockCLLocationManager.swift
//  WeatherAppTests
//
//  Created by Pawan on 12/06/24.
//

import Foundation
import CoreLocation

class MockCLLocationManager: CLLocationManager {
	var mockAuthorizationStatus: CLAuthorizationStatus = .notDetermined
	var mockLocation: CLLocation?
	var mockError: Error?

	override var authorizationStatus: CLAuthorizationStatus {
		return mockAuthorizationStatus
	}

	override func requestWhenInUseAuthorization() {
		mockAuthorizationStatus = .authorizedWhenInUse
		delegate?.locationManagerDidChangeAuthorization?(self)
	}

	override func requestLocation() {
		if let location = mockLocation {
			delegate?.locationManager?(self, didUpdateLocations: [location])
		} else {
			let error = NSError(domain: "LocationError", code: 1, userInfo: nil)
			delegate?.locationManager?(self, didFailWithError: error)
		}
	}
}
