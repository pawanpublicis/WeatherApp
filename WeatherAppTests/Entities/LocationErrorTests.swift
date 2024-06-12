//
//  LocationErrorTests.swift
//  WeatherAppTests
//
//  Created by Pawan on 12/06/24.
//

import XCTest
@testable import WeatherApp

class LocationErrorTests: XCTestCase {

	func testAuthorizationDeniedError() {
		let error = LocationError.authorizationDenied
		XCTAssertEqual(error.localizedDescription, "Location authorization denied.")
	}

	func testLocationFailureError() {
		let underlyingError = NSError(domain: "TestError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Underlying error occurred"])
		let error = LocationError.locationFailure(underlyingError)
		XCTAssertEqual(error.localizedDescription, "Underlying error occurred")
	}

	func testUnknownError() {
		let error = LocationError.unknown
		XCTAssertEqual(error.localizedDescription, "An unknown error occurred.")
	}
}
