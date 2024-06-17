//
//  LocationError.swift
//  WeatherApp
//
//  Created by Pawan on 11/06/24.
//

import Foundation

enum LocationError: Error {
	case authorizationDenied
	case locationFailure(Error)
	case unknown

	var localizedDescription: String {
		switch self {
		case .authorizationDenied:
			return "Location authorization denied."
		case .locationFailure(let error):
			return error.localizedDescription
		case .unknown:
			return "An unknown error occurred."
		}
	}
}

extension LocationError: Equatable {
	static func == (lhs: LocationError, rhs: LocationError) -> Bool {
		lhs.localizedDescription == rhs.localizedDescription
	}
}
