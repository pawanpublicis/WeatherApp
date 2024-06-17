//
//  LocationRepositoryProtocol.swift
//  WeatherApp
//
//  Created by Pawan on 16/06/24.
//

import Foundation
import Combine

/// Protocol defining the interface for a location repository.
protocol LocationRepository {

	/// Fetches the current location of the device.
	/// - Returns: The current location.
	/// - Throws: An error if the location data could not be fetched.
	func fetchCurrentLocation() async throws -> Location

	/// Requests the current location of the device.
	/// This method triggers the location service to start fetching the current location.
	func requestLocation()

	/// Indicates whether the app has location authorization.
	var isLocationAuthorized: Bool { get set }

	/// Returns a Future that completes when the authorization status changes.
	/// - Returns: A Future that emits a Bool indicating whether location access is authorized.
	func authorizationStatusFuture() -> Future<Bool, Never>
}
