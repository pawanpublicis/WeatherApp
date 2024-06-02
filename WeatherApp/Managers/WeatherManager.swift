//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Pawan Rai on 26/05/24.
//

import Foundation
import CoreLocation

/// WeatherManager is responsible for managing weather-related operations, such as fetching current weather data.
class WeatherManager: ObservableObject {
	/// The service responsible for making API requests.
	private let apiService: APIService
	
	/// Initializes a new instance of WeatherManager with the specified API service.
	///
	/// - Parameter apiService: The service responsible for making API requests.
	init(apiService: APIService) {
		self.apiService = apiService
	}
	
	/// Fetches current weather data for the specified coordinates.
	///
	/// - Parameters:
	///   - latitude: The latitude of the location.
	///   - longitude: The longitude of the location.
	/// - Returns: The current weather data.
	/// - Throws: An error of type `APIError` if the request or decoding fails.
	func getCurrentWeather(
		_ latitude: CLLocationDegrees,
		longitude: CLLocationDegrees
	) async throws -> WeatherResponse {
		let endpoint = WeatherAPI.Endpoint.weather(latitude: latitude, longitude: longitude)
		return try await apiService.request(endpoint, responseType: WeatherResponse.self)
	}
	
	/// Fetches current weather data for the specified city.
	///
	/// - Parameter name: The name of the city.
	/// - Returns: The current weather data for the city.
	/// - Throws: An error of type `APIError` if the request or decoding fails.
	func getCityWeather(_ name: String) async throws -> WeatherResponse {
		let endPoint = WeatherAPI.Endpoint.cityWeather(cityName: name)
		return try await apiService.request(endPoint, responseType: WeatherResponse.self)
	}
}

