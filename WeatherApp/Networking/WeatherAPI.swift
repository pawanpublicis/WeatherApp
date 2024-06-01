//
//  WeatherAPI.swift
//  WeatherApp
//
//  Created by Pawan on 29/05/24.
//

import Foundation
import CoreLocation

/// WeatherAPIError defines the types of errors that can occur during WeatherAPI requests.
enum WeatherAPIError: Error {
	case requestFailed       // The request failed due to connectivity issues or other reasons.
	case invalidResponse     // The response was invalid, either due to status code or format.
	case decodingFailed      // Failed to decode the response data.
	case badURL              // The URL provided was invalid.
}

/// WeatherAPI contains the base URL and the available endpoints for the service.
enum WeatherAPI {
	/// The base URL for the OpenWeatherMap API.
	static let baseURL = "https://api.openweathermap.org/data/2.5"
	
	/// The API key for accessing the OpenWeatherMap API.
	static let apiKey = "8d71b2ece71e89193b4b6068a3bb3a86"
	
	/// Endpoint defines the different endpoints for the WeatherAPI service.
	enum Endpoint {
		/// Represents the endpoint for fetching weather data by providing latitude and longitude coordinates.
		case weather(latitude: CLLocationDegrees, longitude: CLLocationDegrees)
		
		/// Represents the endpoint for fetching weather data by providing a city name.
		case cityWeather(cityName: String)
		
		/// Constructs the URL for the endpoint.
		var url: URL? {
			var components = URLComponents(string: WeatherAPI.baseURL)
			switch self {
			case .weather:
				components?.path += "/weather"
			case .cityWeather:
				components?.path += "/weather"
			}
			
			components?.queryItems = [
				URLQueryItem(name: "appid", value: WeatherAPI.apiKey),
				URLQueryItem(name: "units", value: "metric")
			]
			
			switch self {
			case .weather(let latitude, let longitude):
				components?.queryItems?.append(contentsOf: [
					URLQueryItem(name: "lat", value: "\(latitude)"),
					URLQueryItem(name: "lon", value: "\(longitude)")
				])
			case .cityWeather(let cityName):
				components?.queryItems?.append(URLQueryItem(name: "q", value: cityName))
			}
			
			return components?.url
		}
		
		/// HTTP method for the endpoint.
		var httpMethod: String {
			return "GET"
		}
	}
}
