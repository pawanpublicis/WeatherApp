//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Pawan on 29/05/24.
//

import Foundation
import Combine

/// APIService protocol defines the contract for making WeatherAPI requests.
protocol APIService {
	/// Makes an WeatherAPI request using async/await and returns the decoded response.
	///
	/// - Parameters:
	///   - endpoint: The endpoint to request.
	///   - responseType: The type of the response model.
	/// - Returns: The decoded response model.
	/// - Throws: An `WeatherAPIError` if the request or decoding fails.
	func request<T: Decodable>(_ endpoint: WeatherAPI.Endpoint, responseType: T.Type) async throws -> T
}

/// WeatherService is responsible for making WeatherAPI requests.
class WeatherService: APIService {
	/// Makes an WeatherAPI request using async/await and returns the decoded response.
	/// - Parameters:
	///   - endpoint: The endpoint to request.
	///   - responseType: The type of the response model.
	/// - Returns: The decoded response model.
	/// - Throws: An WeatherAPIError if the request or decoding fails.
	func request<T: Decodable>(_ endpoint: WeatherAPI.Endpoint, responseType: T.Type) async throws -> T {
		guard let url = endpoint.url else {
			throw WeatherAPIError.badURL
		}
		
		var request = URLRequest(url: url)
		request.httpMethod = endpoint.httpMethod
		
		do {
			let (data, response) = try await URLSession.shared.data(for: request)
			guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
				throw WeatherAPIError.invalidResponse
			}
			let decodedData = try JSONDecoder().decode(T.self, from: data)
			return decodedData
		} catch {
			if error is URLError {
				throw WeatherAPIError.requestFailed
			} else if error is DecodingError {
				throw WeatherAPIError.decodingFailed
			} else {
				throw WeatherAPIError.invalidResponse
			}
		}
	}
}
