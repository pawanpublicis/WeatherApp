//
//  MockWeatherService.swift
//  WeatherAppTests
//
//  Created by Pawan on 12/06/24.
//

import Foundation
import Combine

@testable import WeatherApp

class MockWeatherService: WeatherServiceProtocol {
	func fetchWeather(for city: String) async throws -> WeatherResponse {
		return WeatherResponse(
			coord: WeatherResponse.CoordinatesResponse(lon: 0, lat: 0),
			weather: [WeatherResponse.WeatherDetailsResponse(id: 800, main: "Clear", description: "clear sky", icon: "01d")],
			main: WeatherResponse.MainResponse(temp: 20.0, feels_like: 20.0, temp_min: 15.0, temp_max: 25.0, pressure: 1013, humidity: 40),
			name: city,
			wind: WeatherResponse.WindResponse(speed: 1.5, deg: 0)
		)
	}

	func fetchWeather(for location: Location) async throws -> WeatherResponse {
		return WeatherResponse(
			coord: WeatherResponse.CoordinatesResponse(lon: location.longitude, lat: location.latitude),
			weather: [WeatherResponse.WeatherDetailsResponse(id: 800, main: "Clear", description: "clear sky", icon: "01d")],
			main: WeatherResponse.MainResponse(temp: 20.0, feels_like: 20.0, temp_min: 15.0, temp_max: 25.0, pressure: 1013, humidity: 40),
			name: "Mock City",
			wind: WeatherResponse.WindResponse(speed: 1.5, deg: 0)
		)
	}
}
