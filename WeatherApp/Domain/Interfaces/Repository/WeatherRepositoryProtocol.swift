//
//  WeatherRepositoryProtocol.swift
//  WeatherApp
//
//  Created by Pawan on 16/06/24.
//

import Foundation

protocol WeatherRepository {
	func fetchWeather(for city: String) async throws -> WeatherResponse
	func fetchWeather(for location: Location) async throws -> WeatherResponse
}
