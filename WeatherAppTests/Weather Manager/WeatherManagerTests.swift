//
//  WeatherManagerTests.swift
//  WeatherAppTests
//
//  Created by Pawan on 02/06/24.
//

import XCTest
@testable import WeatherApp

class WeatherManagerTests: XCTestCase {
	//
	var weatherManager: WeatherManager!
	var mockAPIService: MockAPIService!
	
	override func setUp() {
		super.setUp()
		mockAPIService = MockAPIService()
		weatherManager = WeatherManager(apiService: mockAPIService)
	}
	
	override func tearDown() {
		weatherManager = nil
		mockAPIService = nil
		super.tearDown()
	}
	
	func testGetCurrentWeatherSuccess() async throws {
		// Arrange
		let expectedWeather = WeatherResponse(
			coord: WeatherResponse.CoordinatesResponse(
				lon: -122.4194,
				lat: 37.7749
			),
			weather: [WeatherResponse.WeatherDetailsResponse(
				id: 800,
				main: "Clear",
				description: "clear sky",
				icon: "01d"
			)],
			main: WeatherResponse.MainResponse(
				temp: 25.0,
				feels_like: 25.0,
				temp_min: 20.0,
				temp_max: 30.0,
				pressure: 1013,
				humidity: 60
			),
			name: "Noida",
			wind: WeatherResponse.WindResponse(
				speed: 5.0,
				deg: 270
			)
		)
		mockAPIService.mockWeatherResponse = expectedWeather
		
		// Act
		let location = Location(latitude: 37.7749, longitude: -122.4194)
		let result = try await weatherManager.fetchWeather(for: location)
		
		// Assert
		XCTAssertEqual(result.coord.lat, expectedWeather.coord.lat)
		XCTAssertEqual(result.coord.lon, expectedWeather.coord.lon)
		XCTAssertEqual(result.weather.first?.main, expectedWeather.weather.first?.main)
		XCTAssertEqual(result.main.temp, expectedWeather.main.temp)
		XCTAssertEqual(result.name, expectedWeather.name)
		XCTAssertEqual(result.wind.speed, expectedWeather.wind.speed)
	}
	
	func testGetCurrentWeatherFailure() async {
		// Arrange
		let expectedError = WeatherAPIError.requestFailed
		mockAPIService.mockError = expectedError
		
		// Act
		do {
			let location = Location(latitude: 37.7749, longitude: -122.4194)
			_ = try await weatherManager.fetchWeather(for: location)
			XCTFail("Expected error to be thrown")
		} catch {
			// Assert
			XCTAssertEqual(error as? WeatherAPIError, expectedError)
		}
	}
	
	func testGetCityWeatherSuccess() async throws {
		// Arrange
		let expectedWeather = WeatherResponse(
			coord: WeatherResponse.CoordinatesResponse(
				lon: -122.4194,
				lat: 37.7749
			),
			weather: [WeatherResponse.WeatherDetailsResponse(
				id: 800,
				main: "Clear",
				description: "clear sky",
				icon: "01d"
			)],
			main: WeatherResponse.MainResponse(
				temp: 22.0,
				feels_like: 22.0,
				temp_min: 18.0,
				temp_max: 26.0,
				pressure: 1015,
				humidity: 55
			),
			name: "Noida",
			wind: WeatherResponse.WindResponse(
				speed: 3.0,
				deg: 180
			)
		)
		mockAPIService.mockWeatherResponse = expectedWeather
		
		// Act
		let result = try await weatherManager.fetchWeather(for: "Noida")
		
		// Assert
		XCTAssertEqual(result.coord.lat, expectedWeather.coord.lat)
		XCTAssertEqual(result.coord.lon, expectedWeather.coord.lon)
		XCTAssertEqual(result.weather.first?.main, expectedWeather.weather.first?.main)
		XCTAssertEqual(result.main.temp, expectedWeather.main.temp)
		XCTAssertEqual(result.name, expectedWeather.name)
		XCTAssertEqual(result.wind.speed, expectedWeather.wind.speed)
	}
	
	func testGetCityWeatherFailure() async {
		// Arrange
		let expectedError = WeatherAPIError.decodingFailed
		mockAPIService.mockError = expectedError
		
		// Act
		do {
			_ = try await weatherManager.fetchWeather(for: "Noida")
			XCTFail("Expected error to be thrown")
		} catch {
			// Assert
			XCTAssertEqual(error as? WeatherAPIError, expectedError)
		}
	}
}

