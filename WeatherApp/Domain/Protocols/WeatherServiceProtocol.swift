//
//  WeatherServiceProtocol.swift
//  WeatherApp
//
//  Created by Pawan on 06/06/24.
//

import Foundation
import Combine

/// Protocol defining the weather service's interface.
protocol WeatherServiceProtocol {
	
	/// Fetches the weather data for the specified city.
	/// - Parameter city: The name of the city for which to fetch weather data.
	/// - Returns: The weather data or an error.
	func fetchWeather(for city: String) async throws -> WeatherResponse
	
	/// Fetches the weather data for the specified location.
	/// - Parameter location: The location (latitude and longitude) for which to fetch weather data.
	/// - Returns: The weather data or an error.
	func fetchWeather(for location: Location) async throws -> WeatherResponse
}
