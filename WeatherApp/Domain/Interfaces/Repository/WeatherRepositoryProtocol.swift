//
//  WeatherRepositoryProtocol.swift
//  WeatherApp
//
//  Created by Pawan on 16/06/24.
//

import Foundation

/// Protocol defining the interface for a weather repository.
protocol WeatherRepository {
	
	/// Fetches the weather data for the specified city.
	/// - Parameter city: The name of the city for which to fetch weather data.
	/// - Returns: The weather data for the specified city.
	/// - Throws: An error if the weather data could not be fetched.
	func fetchWeather(for city: String) async throws -> WeatherResponse
	
	/// Fetches the weather data for the specified location.
	/// - Parameter location: The location (latitude and longitude) for which to fetch weather data.
	/// - Returns: The weather data for the specified location.
	/// - Throws: An error if the weather data could not be fetched.
	func fetchWeather(for location: Location) async throws -> WeatherResponse
}
