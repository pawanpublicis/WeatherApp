//
//  MockWeatherRepository.swift
//  WeatherAppTests
//
//  Created by Pawan on 17/06/24.
//

import Foundation
import Combine

@testable import WeatherApp

class MockWeatherRepository: WeatherRepository {
	
	var mockWeatherResponse: WeatherResponse?
	var mockError: Error?
	
	func fetchWeather(for city: String) async throws -> WeatherResponse {
		if let error = mockError {
			throw error
		}
		
		if let response = mockWeatherResponse {
			return response
		}
		
		throw NSError(domain: "MockWeatherRepositoryError", code: -1, userInfo: nil)
	}
	
	func fetchWeather(for location: Location) async throws -> WeatherResponse {
		if let error = mockError {
			throw error
		}
		
		if let response = mockWeatherResponse {
			return response
		}
		
		throw NSError(domain: "MockWeatherRepositoryError", code: -1, userInfo: nil)
	}
}
