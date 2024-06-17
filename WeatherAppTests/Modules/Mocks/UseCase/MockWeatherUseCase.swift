//
//  MockWeatherUseCase.swift
//  WeatherAppTests
//
//  Created by Pawan on 17/06/24.
//

import Foundation

@testable import WeatherApp

class MockWeatherUseCase: WeatherUseCaseProtocol {
	
	var mockWeather: Weather?
	var mockError: Error?
	
	func fetchWeather(for city: String) async throws -> Weather {
		if let error = mockError {
			throw error
		}
		
		if let weather = mockWeather {
			return weather
		}
		
		throw NSError(domain: "MockWeatherUseCaseError", code: -1, userInfo: nil)
	}
	
	func fetchWeather(for location: Location) async throws -> Weather {
		if let error = mockError {
			throw error
		}
		
		if let weather = mockWeather {
			return weather
		}
		
		throw NSError(domain: "MockWeatherUseCaseError", code: -1, userInfo: nil)
	}
}
