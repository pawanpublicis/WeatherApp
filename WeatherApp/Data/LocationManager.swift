//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Pawan Rai on 26/05/24.
//

import Foundation
import CoreLocation
import Combine

import Foundation
import CoreLocation
import Combine

/// LocationManager class to handle location updates and authorization status.
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate, LocationServiceProtocol {
	
	/// The CLLocationManager instance responsible for fetching the location.
	private var manager: CLLocationManager
	
	/// A variable to hold the location authorization changes
	private var authorizationStatusPromise: ((Result<Bool, Never>) -> Void)?
	
	/// A variable to hold the current continuation for location updates.
	private var locationContinuation: CheckedContinuation<Location, Error>?

	/// Private property to indicate if the app has location authorization.
	@Published var isLocationAuthorized: Bool = false {
		didSet {
			authorizationStatusPromise?(.success(isLocationAuthorized))
			authorizationStatusPromise = nil
		}
	}

	/// Initializes the LocationManager and checks authorization status.
	/// - Parameter manager: An optional CLLocationManager instance. Defaults to a new instance if not provided.
	init(manager: CLLocationManager = CLLocationManager()) {
		self.manager = manager
		super.init()
		self.manager.delegate = self
		checkAuthorizationStatus()
	}

	/// Checks the authorization status of the location services.
	/// Updates the `isAuthorized` property based on the current authorization status.
	func checkAuthorizationStatus() {
		switch manager.authorizationStatus {
		case .authorizedWhenInUse, .authorizedAlways:
			isLocationAuthorized = true
		case .notDetermined:
			manager.requestWhenInUseAuthorization()
		default:
			isLocationAuthorized = false
		}
	}
	
	/// Returns a Future that completes when the authorization status changes.
	func authorizationStatusFuture() -> Future<Bool, Never> {
		return Future { promise in
			self.authorizationStatusPromise = promise
		}
	}

	/// Requests the current location of the device.
	func requestLocation() {
		manager.requestLocation()
	}

	/// Fetches the current location.
	/// - Returns: The current location or an error.
	func fetchCurrentLocation() async throws -> Location {
		guard isLocationAuthorized else {
			throw LocationError.authorizationDenied
		}

		return try await withCheckedThrowingContinuation { continuation in
			locationContinuation = continuation
			requestLocation()
		}
	}

	/// CLLocationManagerDelegate method called when new location data is available.
	/// - Parameters:
	///   - manager: The location manager object that generated the update event.
	///   - locations: An array of CLLocation objects containing the location data.
	func locationManager(
		_ manager: CLLocationManager,
		didUpdateLocations locations: [CLLocation]
	) {
		if let location = locations.first {
			let loc = Location(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
			locationContinuation?.resume(returning: loc)
			locationContinuation = nil
		}
	}

	/// CLLocationManagerDelegate method called when the location manager was unable to retrieve the location.
	/// - Parameters:
	///   - manager: The location manager object that generated the error.
	///   - error: The error object containing the reason for the failure.
	func locationManager(
		_ manager: CLLocationManager,
		didFailWithError error: Error
	) {
		locationContinuation?.resume(throwing: LocationError.locationFailure(error))
		locationContinuation = nil
	}

	/// CLLocationManagerDelegate method called when the authorization status changes.
	/// - Parameter manager: The location manager object that generated the event.
	func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
		checkAuthorizationStatus()
	}
}
