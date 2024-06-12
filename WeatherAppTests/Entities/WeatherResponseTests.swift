//
//  WeatherResponseTests.swift
//  WeatherAppTests
//
//  Created by Pawan on 12/06/24.
//

import XCTest
@testable import WeatherApp

class WeatherResponseTests: XCTestCase {
	//
	func testWeatherResponseDecoding() throws {
		let json = """
		{
			"coord": {
				"lon": -122.4194,
				"lat": 37.7749
			},
			"weather": [
				{
					"id": 800,
					"main": "Clear",
					"description": "clear sky",
					"icon": "01d"
				}
			],
			"main": {
				"temp": 20.0,
				"feels_like": 20.0,
				"temp_min": 15.0,
				"temp_max": 25.0,
				"pressure": 1013,
				"humidity": 40
			},
			"name": "San Francisco",
			"wind": {
				"speed": 1.5,
				"deg": 0
			}
		}
		""".data(using: .utf8)!

		let decoder = JSONDecoder()
		let weatherResponse = try decoder.decode(WeatherResponse.self, from: json)

		XCTAssertEqual(weatherResponse.coord.lon, -122.4194)
		XCTAssertEqual(weatherResponse.coord.lat, 37.7749)
		XCTAssertEqual(weatherResponse.weather.first?.id, 800)
		XCTAssertEqual(weatherResponse.weather.first?.main, "Clear")
		XCTAssertEqual(weatherResponse.weather.first?.description, "clear sky")
		XCTAssertEqual(weatherResponse.weather.first?.icon, "01d")
		XCTAssertEqual(weatherResponse.main.temp, 20.0)
		XCTAssertEqual(weatherResponse.main.feelsLike, 20.0)
		XCTAssertEqual(weatherResponse.main.tempMin, 15.0)
		XCTAssertEqual(weatherResponse.main.tempMax, 25.0)
		XCTAssertEqual(weatherResponse.main.pressure, 1013)
		XCTAssertEqual(weatherResponse.main.humidity, 40)
		XCTAssertEqual(weatherResponse.name, "San Francisco")
		XCTAssertEqual(weatherResponse.wind.speed, 1.5)
		XCTAssertEqual(weatherResponse.wind.deg, 0)
	}
}
