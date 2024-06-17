//
//  WeatherServiceProtocol.swift
//  WeatherApp
//
//  Created by Pawan on 16/06/24.
//

import Foundation

/// WeatherServiceProtocol protocol defines the contract for making WeatherAPI requests.
protocol WeatherServiceProtocol {
	/// Makes an WeatherAPI request using async/await and returns the decoded response.
	///
	/// - Parameters:
	///   - endpoint: The endpoint to request.
	///   - responseType: The type of the response model.
	/// - Returns: The decoded response model.
	/// - Throws: An `WeatherAPIError` if the request or decoding fails.
	func request<T: Decodable>(_ endpoint: WeatherAPI.Endpoint, responseType: T.Type) async throws -> T
}
