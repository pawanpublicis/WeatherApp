//
//  WeatherUseCase.swift
//  WeatherApp
//
//  Created by Pawan on 16/06/24.
//

import Foundation

/// Use case responsible for fetching weather data.
final class WeatherUseCase: WeatherUseCaseProtocol {

	/// The weather repository used to fetch weather data.
	private let repository: WeatherRepository

	/// Initializes the WeatherUseCase with the provided repository.
	/// - Parameter repository: The weather repository used to fetch weather data.
	init(repository: WeatherRepository) {
		self.repository = repository
	}

	/// Fetches the weather data for the specified city.
	/// - Parameter city: The name of the city for which to fetch weather data.
	/// - Returns: The domain model representing the weather data.
	/// - Throws: An error if the weather data could not be fetched.
	func fetchWeather(for city: String) async throws -> Weather {
		try await repository.fetchWeather(for: city).toDomain()
	}

	/// Fetches the weather data for the specified location.
	/// - Parameter location: The location for which to fetch weather data.
	/// - Returns: The domain model representing the weather data.
	/// - Throws: An error if the weather data could not be fetched.
	func fetchWeather(for location: Location) async throws -> Weather {
		try await repository.fetchWeather(for: location).toDomain()
	}
}
