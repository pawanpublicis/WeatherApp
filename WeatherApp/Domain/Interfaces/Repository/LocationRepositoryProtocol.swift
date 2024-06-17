//
//  LocationRepositoryProtocol.swift
//  WeatherApp
//
//  Created by Pawan on 16/06/24.
//

import Foundation
import Combine

protocol LocationRepository {
	func fetchCurrentLocation() async throws -> Location
	func requestLocation()
	var isLocationAuthorized: Bool { get set }
	func authorizationStatusFuture() -> Future<Bool, Never>
}
