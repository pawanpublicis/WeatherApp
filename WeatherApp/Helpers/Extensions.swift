//
//  Extensions.swift
//  WeatherApp
//
//  Created by Pawan Rai on 26/05/24.
//

import Foundation
import SwiftUI

// Extension for rounded Double to 0 decimals
extension Double {
    func roundDouble() -> String {
        return String(format: "%.0f", self)
    }
}


// Extension for adding rounded corners to specific corners
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners) )
    }
}

// Custom RoundedCorner shape used for cornerRadius extension above
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

import CoreLocation

/// Extension to make `CLLocationCoordinate2D` conform to `Equatable`.
extension CLLocationCoordinate2D: Equatable {
	/// Method to compare two `CLLocationCoordinate2D` instances for equality.
	/// - Parameters:
	///   - lhs: The left-hand side `CLLocationCoordinate2D` instance.
	///   - rhs: The right-hand side `CLLocationCoordinate2D` instance.
	/// - Returns: A Boolean value indicating whether the two instances are equal.
	public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
		return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
	}
}

/// Function to get the weather icon based on the weather condition code.
/// - Parameter condition: An integer representing the weather condition code.
/// - Returns: A String representing an emoji corresponding to the weather condition.
func getWeatherIcon(condition: Int) -> String {
	if condition < 300 {
		return "🌩"
	} else if condition < 400 {
		return "🌧"
	} else if condition < 600 {
		return "☔️"
	} else if condition < 700 {
		return "☃️"
	} else if condition < 800 {
		return "🌫"
	} else if condition == 800 {
		return "☀️"
	} else if condition <= 804 {
		return "☁️"
	} else {
		return "🤷‍"
	}
}
