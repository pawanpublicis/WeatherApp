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
	var mockWeatherService: MockWeatherService!
	var mockLocationService: MockLocationService!
	var cancellables: Set<AnyCancellable>!

	override func setUp() {
		super.setUp()
		mockWeatherService = MockWeatherService()
		mockLocationService = MockLocationService()
		weatherViewModel = WeatherViewModel(weatherService: mockWeatherService, locationService: mockLocationService)
		cancellables = []
	}

	override func tearDown() {
		weatherViewModel = nil
		mockWeatherService = nil
		mockLocationService = nil
		cancellables = nil
		super.tearDown()
	}

	func testFetchWeatherForCity() {
		let expectation = self.expectation(description: "Fetch weather for city")
		let cityName = "San Francisco"
		
		weatherViewModel.$weather
			.dropFirst()
			.sink { weather in
				if let weather = weather {
					XCTAssertEqual(weather.name, cityName)
					XCTAssertEqual(weather.weather.first?.main, "Clear")
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
		
		weatherViewModel.$weather
			.dropFirst()
			.sink { weather in
				if let weather = weather {
					XCTAssertEqual(weather.name, "Mock City")
					XCTAssertEqual(weather.weather.first?.main, "Clear")
					expectation.fulfill()
				}
			}
			.store(in: &cancellables)

		weatherViewModel.fetchWeather(for: location)
		
		wait(for: [expectation], timeout: 5.0)
	}

	func testFetchWeatherForCurrentLocation() {
		let expectation = self.expectation(description: "Fetch weather for current location")
		mockLocationService.mockLocation = CLLocation(latitude: 37.7749, longitude: -122.4194)
		mockLocationService.isLocationAuthorized = true
		
		weatherViewModel.$weather
			.dropFirst()
			.sink { weather in
				if let weather = weather {
					XCTAssertEqual(weather.name, "Mock City")
					XCTAssertEqual(weather.weather.first?.main, "Clear")
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
