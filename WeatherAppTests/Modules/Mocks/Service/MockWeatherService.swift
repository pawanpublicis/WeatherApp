//
//  MockWeatherService.swift
//  WeatherAppTests
//
//  Created by Pawan on 17/06/24.
//

import Foundation

@testable import WeatherApp

class MockWeatherService: WeatherServiceProtocol {
	//
	var mockResponse: Any?
	var mockError: WeatherAPIError?
	//
	func request<T: Decodable>(_ endpoint: WeatherAPI.Endpoint, responseType: T.Type) async throws -> T {
		if let error = mockError {
			throw error
		}
		
		if let response = mockResponse as? T {
			return response
		}
		
		throw WeatherAPIError.invalidResponse
	}
}
