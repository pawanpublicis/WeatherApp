//
//  MockCLLocationManager.swift
//  WeatherAppTests
//
//  Created by Pawan on 02/06/24.
//

import Foundation
import CoreLocation

class MockCLLocationManager: CLLocationManager {
	var mockAuthorizationStatus: CLAuthorizationStatus = .notDetermined
	var mockLocation: CLLocation?
	weak var mockDelegate: CLLocationManagerDelegate?

	override var authorizationStatus: CLAuthorizationStatus {
		return mockAuthorizationStatus
	}

	override var delegate: CLLocationManagerDelegate? {
		get {
			return mockDelegate
		}
		set {
			mockDelegate = newValue
		}
	}
	
	override func requestWhenInUseAuthorization() {
		mockAuthorizationStatus = .authorizedWhenInUse
		delegate?.locationManagerDidChangeAuthorization?(self)
	}

	override func requestLocation() {
		if let location = mockLocation {
			delegate?.locationManager?(self, didUpdateLocations: [location])
		} else {
			delegate?.locationManager?(self, didFailWithError: NSError(domain: "LocationError", code: 1, userInfo: nil))
		}
	}
}
