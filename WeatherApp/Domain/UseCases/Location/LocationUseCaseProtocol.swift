//
//  LocationUseCaseProtocol.swift
//  WeatherApp
//
//  Created by Pawan on 16/06/24.
//

import Foundation

import Combine

/// Protocol defining the location service's interface.
protocol LocationUseCaseProtocol {
	
	/// Fetches the current location.
	/// - Returns: The current location or an error.
	func fetchCurrentLocation() async throws -> Location
	
	/// Requests the current location of the device.
	func requestLocation()
	
	/// Provides the current status of location permission.
	var isLocationAuthorized: Bool { get }
	
	/// Returns a Future that completes when the authorization status changes.
	func authorizationStatusFuture() -> Future<Bool, Never>
}
