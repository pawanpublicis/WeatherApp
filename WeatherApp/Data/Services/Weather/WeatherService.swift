//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Pawan on 17/06/24.
//

import Foundation

/// WeatherService is responsible for making WeatherAPI requests.
final class WeatherService: WeatherServiceProtocol {
	//
	let session: URLSession
	
	init(session: URLSession = URLSession.shared) {
		self.session = session
	}
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
			let (data, response) = try await session.data(for: request)
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
