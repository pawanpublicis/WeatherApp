//
//  WeatherUseCase.swift
//  WeatherApp
//
//  Created by Pawan on 16/06/24.
//

import Foundation

final class WeatherUseCase: WeatherUseCaseProtocol {
	
	private let repository: WeatherRepository
	
	init(repository: WeatherRepository) {
		self.repository = repository
	}
	
	func fetchWeather(for city: String) async throws -> Weather {
		try await repository.fetchWeather(for: city).toDomain()
	}
	
	func fetchWeather(for location: Location) async throws -> Weather {
		try await repository.fetchWeather(for: location).toDomain()
	}
	
}
