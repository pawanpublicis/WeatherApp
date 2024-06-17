//
//  LocationRepository.swift
//  WeatherApp
//
//  Created by Pawan on 16/06/24.
//

import Foundation
import Combine

final class DefaultLocationRepository: LocationRepository {
	
	let service: LocationServiceProtocol
	var isLocationAuthorized: Bool
	
	init(service: LocationServiceProtocol, isLocationAuthorized: Bool) {
		self.service = service
		self.isLocationAuthorized = isLocationAuthorized
	}
	
	func fetchCurrentLocation() async throws -> Location {
		try await service.fetchCurrentLocation()
	}
	
	func requestLocation() {
		service.requestLocation()
	}
	
	func authorizationStatusFuture() -> Future<Bool, Never> {
		service.authorizationStatusFuture()
	}
	
}
