//
//  LocationRepository.swift
//  WeatherApp
//
//  Created by Pawan on 16/06/24.
//

import Foundation
import Combine

/// Default implementation of the LocationRepository protocol.
final class DefaultLocationRepository: LocationRepository {

	/// The location service used to manage location data.
	private let service: LocationServiceProtocol
	
	/// Indicates whether the app has location authorization.
	internal var isLocationAuthorized: Bool
	
	/// Initializes the DefaultLocationRepository with the provided service and authorization status.
	/// - Parameters:
	///   - service: The location service used to manage location data.
	///   - isLocationAuthorized: A Boolean value indicating whether the app has location authorization.
	init(service: LocationServiceProtocol, isLocationAuthorized: Bool) {
		self.service = service
		self.isLocationAuthorized = isLocationAuthorized
	}
	
	/// Fetches the current location of the device.
	/// - Returns: The current location.
	/// - Throws: An error if the location data could not be fetched.
	func fetchCurrentLocation() async throws -> Location {
		try await service.fetchCurrentLocation()
	}
	
	/// Requests the current location of the device.
	/// This method triggers the location service to start fetching the current location.
	func requestLocation() {
		service.requestLocation()
	}
	
	/// Returns a Future that completes when the authorization status changes.
	/// - Returns: A Future that emits a Bool indicating whether location access is authorized.
	func authorizationStatusFuture() -> Future<Bool, Never> {
		service.authorizationStatusFuture()
	}
}
