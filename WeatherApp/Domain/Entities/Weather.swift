//
//  Weather.swift
//  WeatherApp
//
//  Created by Pawan on 06/06/24.
//

import Foundation

/// Model of the response body we get from calling the OpenWeather API
struct WeatherResponse: Decodable {
	var coord: CoordinatesResponse
	var weather: [WeatherResponse.WeatherDetailsResponse]
	var main: MainResponse
	var name: String
	var wind: WindResponse

	/// Nested struct representing the coordinates
	struct CoordinatesResponse: Decodable {
		var lon: Double
		var lat: Double
	}

	/// Nested struct representing weather details
	struct WeatherDetailsResponse: Decodable {
		var id: Double
		var main: String
		var description: String
		var icon: String
	}

	/// Nested struct representing main weather information
	struct MainResponse: Decodable {
		var temp: Double
		var feels_like: Double
		var temp_min: Double
		var temp_max: Double
		var pressure: Double
		var humidity: Double
		
		/// Computed properties to provide more Swift-like property names
		var feelsLike: Double { return feels_like }
		var tempMin: Double { return temp_min }
		var tempMax: Double { return temp_max }
	}
	
	/// Nested struct representing wind information
	struct WindResponse: Decodable {
		var speed: Double
		var deg: Double
	}
}
