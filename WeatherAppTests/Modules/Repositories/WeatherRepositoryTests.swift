//
//  WeatherRepositoryTests.swift
//  WeatherAppTests
//
//  Created by Pawan on 17/06/24.
//

import XCTest
@testable import WeatherApp

final class DefaultWeatherRepositoryTests: XCTestCase {
	var weatherRepository: DefaultWeatherRepository!
	var mockWeatherService: MockWeatherService!

	override func setUp() {
		super.setUp()
		mockWeatherService = MockWeatherService()
		weatherRepository = DefaultWeatherRepository(service: mockWeatherService)
	}

	override func tearDown() {
		weatherRepository = nil
		mockWeatherService = nil
		super.tearDown()
	}

	func testFetchWeatherForCitySuccess() async throws {
		let mockResponse = WeatherResponse(
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
				temp: 75.0,
				feels_like: 74.0,
				temp_min: 72.0,
				temp_max: 78.0,
				pressure: 1012,
				humidity: 60
			),
			name: "San Francisco",
			wind: WeatherResponse.WindResponse(
				speed: 5.0,
				deg: 270
			)
		)
		mockWeatherService.mockResponse = mockResponse
		
		let response = try await weatherRepository.fetchWeather(for: "San Francisco")
		
		XCTAssertEqual(response.name, "San Francisco")
		XCTAssertEqual(response.main.temp, 75.0)
		XCTAssertEqual(response.weather.first?.main, "Clear")
	}

	func testFetchWeatherForCityFailure() async {
		mockWeatherService.mockError = WeatherAPIError.requestFailed
		
		do {
			let _ = try await weatherRepository.fetchWeather(for: "San Francisco")
			XCTFail("Expected fetchWeather to throw, but it did not")
		} catch {
			XCTAssertEqual(error as? WeatherAPIError, WeatherAPIError.requestFailed)
		}
	}

	func testFetchWeatherForLocationSuccess() async throws {
		let mockResponse = WeatherResponse(
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
				temp: 75.0,
				feels_like: 74.0,
				temp_min: 72.0,
				temp_max: 78.0,
				pressure: 1012,
				humidity: 60
			),
			name: "San Francisco",
			wind: WeatherResponse.WindResponse(
				speed: 5.0,
				deg: 270
			)
		)
		mockWeatherService.mockResponse = mockResponse
		
		let location = Location(latitude: 37.7749, longitude: -122.4194)
		let response = try await weatherRepository.fetchWeather(for: location)
		
		XCTAssertEqual(response.name, "San Francisco")
		XCTAssertEqual(response.main.temp, 75.0)
		XCTAssertEqual(response.weather.first?.main, "Clear")
	}

	func testFetchWeatherForLocationFailure() async {
		mockWeatherService.mockError = WeatherAPIError.requestFailed
		
		let location = Location(latitude: 37.7749, longitude: -122.4194)
		
		do {
			let _ = try await weatherRepository.fetchWeather(for: location)
			XCTFail("Expected fetchWeather to throw, but it did not")
		} catch {
			XCTAssertEqual(error as? WeatherAPIError, WeatherAPIError.requestFailed)
		}
	}
}
