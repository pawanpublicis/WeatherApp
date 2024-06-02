//
//  MockAPIService.swift
//  WeatherAppTests
//
//  Created by Pawan on 02/06/24.
//

import Foundation
@testable import WeatherApp

class MockAPIService: APIService {
	var mockWeatherResponse: WeatherResponse?
	var mockError: Error?

	func request<T>(_ endpoint: WeatherAPI.Endpoint, responseType: T.Type) async throws -> T where T : Decodable {
		if let error = mockError {
			throw error
		}
		if let response = mockWeatherResponse as? T {
			return response
		}
		throw WeatherAPIError.invalidResponse
	}
}
