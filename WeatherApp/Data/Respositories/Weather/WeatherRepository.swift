//
//  WeatherRepository.swift
//  WeatherApp
//
//  Created by Pawan on 16/06/24.
//

import Foundation
import CoreLocation

final class DefaultWeatherRepository: WeatherRepository {
	
	let service: WeatherServiceProtocol
	
	init(service: WeatherServiceProtocol) {
		self.service = service
	}
	
	func fetchWeather(for city: String) async throws -> WeatherResponse {
		let endPoint = WeatherAPI.Endpoint.cityWeather(cityName: city)
		return try await service.request(endPoint, responseType: WeatherResponse.self)
	}
	
	func fetchWeather(for location: Location) async throws -> WeatherResponse {
		let endpoint = WeatherAPI.Endpoint.weather(
			latitude: location.latitude,
			longitude: location.longitude
		)
		return try await service.request(endpoint, responseType: WeatherResponse.self)
	}
	
}
