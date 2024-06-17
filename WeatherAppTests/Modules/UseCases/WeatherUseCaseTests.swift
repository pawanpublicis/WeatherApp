//
//  WeatherUseCaseTests.swift
//  WeatherAppTests
//
//  Created by Pawan on 17/06/24.
//

import XCTest
@testable import WeatherApp

final class WeatherUseCaseTests: XCTestCase {
	var weatherUseCase: WeatherUseCase!
	var mockWeatherRepository: MockWeatherRepository!

	override func setUp() {
		super.setUp()
		mockWeatherRepository = MockWeatherRepository()
		weatherUseCase = WeatherUseCase(repository: mockWeatherRepository)
	}

	override func tearDown() {
		weatherUseCase = nil
		mockWeatherRepository = nil
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
		mockWeatherRepository.mockWeatherResponse = mockResponse
		
		let weather = try await weatherUseCase.fetchWeather(for: "San Francisco")
		
		XCTAssertEqual(weather.tempMax, "78°")
		XCTAssertEqual(weather.condition, "Clear")
	}

	func testFetchWeatherForCityFailure() async {
		mockWeatherRepository.mockError = WeatherAPIError.requestFailed
		
		do {
			let _ = try await weatherUseCase.fetchWeather(for: "San Francisco")
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
		mockWeatherRepository.mockWeatherResponse = mockResponse
		
		let location = Location(latitude: 37.7749, longitude: -122.4194)
		let weather = try await weatherUseCase.fetchWeather(for: location)
		
		XCTAssertEqual(weather.tempMax, "78°")
		XCTAssertEqual(weather.condition, "Clear")
	}

	func testFetchWeatherForLocationFailure() async {
		mockWeatherRepository.mockError = WeatherAPIError.requestFailed
		
		let location = Location(latitude: 37.7749, longitude: -122.4194)
		
		do {
			let _ = try await weatherUseCase.fetchWeather(for: location)
			XCTFail("Expected fetchWeather to throw, but it did not")
		} catch {
			XCTAssertEqual(error as? WeatherAPIError, WeatherAPIError.requestFailed)
		}
	}
}
