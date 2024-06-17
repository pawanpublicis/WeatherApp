//
//  WeatherViewModelTests.swift
//  WeatherAppTests
//
//  Created by Pawan on 12/06/24.
//

import XCTest
import Combine
import CoreLocation

@testable import WeatherApp

class WeatherViewModelTests: XCTestCase {
	var weatherViewModel: WeatherViewModel!
	var mockWeatherUseCase: MockWeatherUseCase!
	var mockLocationUseCase: MockLocationUseCase!
	var cancellables: Set<AnyCancellable>!
	
	override func setUp() {
		super.setUp()
		mockWeatherUseCase = MockWeatherUseCase()
		mockLocationUseCase = MockLocationUseCase()
		weatherViewModel = WeatherViewModel(weatherService: mockWeatherUseCase, locationService: mockLocationUseCase)
		cancellables = []
	}
	
	override func tearDown() {
		weatherViewModel = nil
		mockWeatherUseCase = nil
		mockLocationUseCase = nil
		cancellables = nil
		super.tearDown()
	}
	
	func testFetchWeatherForCity() {
		let expectation = self.expectation(description: "Fetch weather for city")
		let cityName = "San Francisco"
		
		let mockWeather = Weather(
			id: 800,
			name: cityName,
			condition: "Clear",
			feelsLike: "74.0",
			tempMin: "72.0",
			tempMax: "78.0",
			windSpeed: "5.0",
			humidity: "60"
		)
		mockWeatherUseCase.mockWeather = mockWeather
		
		weatherViewModel.$weather
			.dropFirst()
			.sink { weather in
				if let weather = weather {
					XCTAssertEqual(weather.name, cityName)
					XCTAssertEqual(weather.condition, "Clear")
					XCTAssertEqual(weather.feelsLike, "74.0")
					XCTAssertEqual(weather.tempMin, "72.0")
					XCTAssertEqual(weather.tempMax, "78.0")
					XCTAssertEqual(weather.windSpeed, "5.0")
					XCTAssertEqual(weather.humidity, "60")
					expectation.fulfill()
				}
			}
			.store(in: &cancellables)
		
		weatherViewModel.fetchWeather(for: cityName)
		
		wait(for: [expectation], timeout: 5.0)
	}
	
	func testFetchWeatherForLocation() {
		let expectation = self.expectation(description: "Fetch weather for location")
		let location = Location(latitude: 37.7749, longitude: -122.4194)
		
		let mockWeather = Weather(
			id: 800,
			name: "Mock City",
			condition: "Clear",
			feelsLike: "74.0",
			tempMin: "72.0",
			tempMax: "78.0",
			windSpeed: "5.0",
			humidity: "60"
		)
		mockWeatherUseCase.mockWeather = mockWeather
		
		weatherViewModel.$weather
			.dropFirst()
			.sink { weather in
				if let weather = weather {
					XCTAssertEqual(weather.name, "Mock City")
					XCTAssertEqual(weather.condition, "Clear")
					XCTAssertEqual(weather.feelsLike, "74.0")
					XCTAssertEqual(weather.tempMin, "72.0")
					XCTAssertEqual(weather.tempMax, "78.0")
					XCTAssertEqual(weather.windSpeed, "5.0")
					XCTAssertEqual(weather.humidity, "60")
					expectation.fulfill()
				}
			}
			.store(in: &cancellables)
		
		weatherViewModel.fetchWeather(for: location)
		
		wait(for: [expectation], timeout: 5.0)
	}
	
	func testFetchWeatherForCurrentLocation() {
		let expectation = self.expectation(description: "Fetch weather for current location")
		mockLocationUseCase.mockLocation = Location(latitude: 37.7749, longitude: -122.4194)
		mockLocationUseCase.mockAuthorizationStatus = true
		
		let mockWeather = Weather(
			id: 800,
			name: "Mock City",
			condition: "Clear",
			feelsLike: "74.0",
			tempMin: "72.0",
			tempMax: "78.0",
			windSpeed: "5.0",
			humidity: "60"
		)
		mockWeatherUseCase.mockWeather = mockWeather
		
		weatherViewModel.$weather
			.dropFirst()
			.sink { weather in
				if let weather = weather {
					XCTAssertEqual(weather.name, "Mock City")
					XCTAssertEqual(weather.condition, "Clear")
					XCTAssertEqual(weather.feelsLike, "74.0")
					XCTAssertEqual(weather.tempMin, "72.0")
					XCTAssertEqual(weather.tempMax, "78.0")
					XCTAssertEqual(weather.windSpeed, "5.0")
					XCTAssertEqual(weather.humidity, "60")
					expectation.fulfill()
				}
			}
			.store(in: &cancellables)
		
		weatherViewModel.fetchWeatherForCurrentLocation()
		
		wait(for: [expectation], timeout: 5.0)
	}
	
	func testIsLoadingState() {
		let expectation = self.expectation(description: "Check loading state")
		let cityName = "San Francisco"
		
		let mockWeather = Weather(
			id: 800,
			name: "Mock City",
			condition: "Clear",
			feelsLike: "74.0",
			tempMin: "72.0",
			tempMax: "78.0",
			windSpeed: "5.0",
			humidity: "60"
		)
		mockWeatherUseCase.mockWeather = mockWeather
		
		mockLocationUseCase.mockAuthorizationStatus = true
		
		var loadingStates: [Bool] = []
		
		weatherViewModel.$isLoading
			.sink { isLoading in
				loadingStates.append(isLoading)
				if loadingStates.count == 3 {
					XCTAssertEqual(loadingStates, [false, true, false])
					expectation.fulfill()
				}
			}
			.store(in: &cancellables)
		
		weatherViewModel.fetchWeather(for: cityName)
		
		wait(for: [expectation], timeout: 5.0)
	}
}
