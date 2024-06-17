//
//  LocationUseCase.swift
//  WeatherApp
//
//  Created by Pawan on 16/06/24.
//

import Foundation
import Combine

final class LocationUseCase: LocationUseCaseProtocol {
	
	private let repository: LocationRepository
	
	init(repository: LocationRepository) {
		self.repository = repository
	}
	
	func fetchCurrentLocation() async throws -> Location {
		try await repository.fetchCurrentLocation()
	}
	
	func requestLocation() {
		repository.requestLocation()
	}
	
	var isLocationAuthorized: Bool {
		repository.isLocationAuthorized
	}
	
	func authorizationStatusFuture() -> Future<Bool, Never> {
		repository.authorizationStatusFuture()
	}
	
}
