//
//  WeatherAppSnapshotsTests.swift
//  WeatherAppTests
//
//  Created by Pawan Rai on 03/06/24.
//

import SnapshotTesting
import SwiftUI
import CoreLocation
import XCTest
@testable import WeatherApp

class WeatherAppSnapshotsTests: XCTestCase {
    //
	func testWelcomeView() throws {
		let mockWeatherViewModel = WeatherViewModel(
			weatherService: MockWeatherService(),
			locationService: MockLocationService()
		)
		let welcomeView = WelcomeView(weatherViewModel: mockWeatherViewModel)
		let view: UIView = UIHostingController(rootView: welcomeView).view
		//
		assertSnapshot(of: view, as: .image(size: view.intrinsicContentSize))
	}
	func testWeatherView() throws {
		//
		let mockWeatherViewModel = WeatherViewModel(
			weatherService: MockWeatherService(),
			locationService: MockLocationService()
		)
		let weatherView = WeatherView(weatherViewModel: mockWeatherViewModel)
		let view: UIView = UIHostingController(rootView: weatherView).view
		//
		assertSnapshot(of: view, as: .image(size: view.intrinsicContentSize))
	}
	func testContentView() throws {
		//
		let mockWeatherViewModel = WeatherViewModel(
			weatherService: MockWeatherService(),
			locationService: MockLocationService()
		)
		let contentView = ContentView(weatherViewModel: mockWeatherViewModel)
		let view: UIView = UIHostingController(rootView: contentView).view
		//
		assertSnapshot(of: view, as: .image(size: view.intrinsicContentSize))
	}
}
