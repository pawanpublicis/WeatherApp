//
//  WeatherRepository.swift
//  WeatherApp
//
//  Created by Pawan on 16/06/24.
//

import Foundation
import CoreLocation

/// Default implementation of the WeatherRepository protocol.
final class DefaultWeatherRepository: WeatherRepository {
	
	/// The weather service used to make API requests.
	let service: WeatherServiceProtocol
	
	/// Initializes the DefaultWeatherRepository with the provided service.
	/// - Parameter service: The weather service used to make API requests.
	init(service: WeatherServiceProtocol) {
		self.service = service
	}
	
	/// Fetches the weather data for the specified city.
	/// - Parameter city: The name of the city for which to fetch weather data.
	/// - Returns: The weather data for the specified city.
	/// - Throws: An error if the weather data could not be fetched.
	func fetchWeather(for city: String) async throws -> WeatherResponse {
		let endPoint = WeatherAPI.Endpoint.cityWeather(cityName: city)
		return try await service.request(endPoint, responseType: WeatherResponse.self)
	}
	
	/// Fetches the weather data for the specified location.
	/// - Parameter location: The location (latitude and longitude) for which to fetch weather data.
	/// - Returns: The weather data for the specified location.
	/// - Throws: An error if the weather data could not be fetched.
	func fetchWeather(for location: Location) async throws -> WeatherResponse {
		let endpoint = WeatherAPI.Endpoint.weather(
			latitude: location.latitude,
			longitude: location.longitude
		)
		return try await service.request(endpoint, responseType: WeatherResponse.self)
	}
}
