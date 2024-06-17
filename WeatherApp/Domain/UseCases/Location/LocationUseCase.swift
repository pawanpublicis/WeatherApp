//
//  LocationUseCase.swift
//  WeatherApp
//
//  Created by Pawan on 16/06/24.
//

import Foundation
import Combine

/// Use case responsible for managing location data.
final class LocationUseCase: LocationUseCaseProtocol {

	/// The location repository used to fetch and manage location data.
	private let repository: LocationRepository

	/// Initializes the LocationUseCase with the provided repository.
	/// - Parameter repository: The location repository used to fetch and manage location data.
	init(repository: LocationRepository) {
		self.repository = repository
	}

	/// Fetches the current location of the device.
	/// - Returns: The current location.
	/// - Throws: An error if the location data could not be fetched.
	func fetchCurrentLocation() async throws -> Location {
		try await repository.fetchCurrentLocation()
	}

	/// Requests the current location of the device.
	/// This method triggers the location service to start fetching the current location.
	func requestLocation() {
		repository.requestLocation()
	}

	/// Indicates whether the app has location authorization.
	var isLocationAuthorized: Bool {
		repository.isLocationAuthorized
	}

	/// Returns a Future that completes when the authorization status changes.
	/// - Returns: A Future that emits a Bool indicating whether location access is authorized.
	func authorizationStatusFuture() -> Future<Bool, Never> {
		repository.authorizationStatusFuture()
	}
}
