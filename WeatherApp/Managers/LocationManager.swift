//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Pawan Rai on 26/05/24.
//

import Foundation
import CoreLocation

/// LocationManager class to handle location updates and authorization status.
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
	//
	var manager: CLLocationManager
	
	/// Published property to store the current location coordinates.
	@Published var location: CLLocationCoordinate2D?
	
	/// Published property to indicate if the location is being fetched.
	@Published var isLoading: Bool = false
	
	/// Published property to indicate if the app has location authorization.
	@Published var isAuthorized: Bool = false
	
	/// Initializes the LocationManager and checks authorization status.
	init(manager: CLLocationManager = CLLocationManager()) {
		self.manager = manager
		super.init()
		self.manager.delegate = self
		checkAuthorizationStatus()
	}
	
	/// Checks the authorization status of the location services.
	func checkAuthorizationStatus() {
		switch manager.authorizationStatus {
		case .authorizedWhenInUse, .authorizedAlways:
			isAuthorized = true
			requestLocation()
		case .notDetermined:
			manager.requestWhenInUseAuthorization()
		default:
			isAuthorized = false
		}
	}
	
	/// Requests the current location of the device.
	func requestLocation() {
		isLoading = true
		manager.requestLocation()
	}
	
	/// CLLocationManagerDelegate method called when new location data is available.
	/// - Parameters:
	///   - manager: The location manager object that generated the update event.
	///   - locations: An array of CLLocation objects containing the location data.
	func locationManager(
		_ manager: CLLocationManager,
		didUpdateLocations locations: [CLLocation]
	) {
		location = locations.first?.coordinate
		isLoading = false
	}
	
	/// CLLocationManagerDelegate method called when the location manager was unable to retrieve the location.
	/// - Parameters:
	///   - manager: The location manager object that generated the error.
	///   - error: The error object containing the reason for the failure.
	func locationManager(
		_ manager: CLLocationManager,
		didFailWithError error: Error
	) {
		debugPrint("Error getting location", error)
		isLoading = false
	}
	
	/// CLLocationManagerDelegate method called when the authorization status changes.
	/// - Parameter manager: The location manager object that generated the event.
	func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
		checkAuthorizationStatus()
	}
}

