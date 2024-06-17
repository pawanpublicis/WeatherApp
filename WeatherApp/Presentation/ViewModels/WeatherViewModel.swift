//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Pawan on 06/06/24.
//

import Foundation
import Combine

class WeatherViewModel: ObservableObject {
	private let weatherService: WeatherUseCaseProtocol
	private let locationService: LocationUseCaseProtocol
	private var cancellables = Set<AnyCancellable>()
	
	@Published var weather: Weather?
	@Published var isLocationAuthorized: Bool = false
	@Published var isLoading: Bool = false

	/// Initializes the WeatherViewModel with the provided services.
	/// - Parameters:
	///   - weatherService: The weather service used to fetch weather data.
	///   - locationService: The location service used to fetch location data.
	init(weatherService: WeatherUseCaseProtocol, locationService: LocationUseCaseProtocol) {
		self.weatherService = weatherService
		self.locationService = locationService
		
		// Subscribe to the authorization status updates
		locationService.authorizationStatusFuture()
			.receive(on: DispatchQueue.main)
			.sink { [weak self] isAuthorized in
				self?.isLocationAuthorized = isAuthorized
			}
			.store(in: &cancellables)
	}
	
	/// Fetches the weather data for the specified city.
	/// - Parameter city: The name of the city for which to fetch weather data.
	func fetchWeather(for city: String) {
		//
		isLoading = true
		//
		Task(priority: .background) {
			do {
				let weather = try await weatherService.fetchWeather(for: city)
				//
				DispatchQueue.main.async {
					self.weather = weather
					self.isLoading = false
				}
			} catch {
				print("Weather fetch error: \(error)")
			}
		}
	}
	
	/// Fetches the weather data for the specified location.
	/// - Parameter location: The location for which to fetch weather data.
	func fetchWeather(for location: Location) {
		//
		isLoading = true
		//
		Task(priority: .background) {
			do {
				let weather = try await weatherService.fetchWeather(for: location)
				//
				DispatchQueue.main.async {
					self.weather = weather
					self.isLoading = false
				}
			} catch {
				print("Weather fetch error: \(error)")
			}
		}
	}
	
	/// Fetches the weather data for the current location.
	func fetchWeatherForCurrentLocation() {
		//
		isLoading = true
		//
		Task(priority: .background) {
			do {
				let location = try await locationService.fetchCurrentLocation()
				let weather = try await weatherService.fetchWeather(for: location)
				//
				DispatchQueue.main.async {
					self.weather = weather
					self.isLoading = false
				}
			} catch {
				print("Location error: \(error.localizedDescription)")
			}
		}
	}
	
	func requestLocation() {
		locationService.requestLocation()
	}
}
