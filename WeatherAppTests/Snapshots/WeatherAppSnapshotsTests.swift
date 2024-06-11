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
		let welcomeView = WelcomeView(
			weatherViewModel:WeatherViewModel(
			 weatherService: WeatherManager(
				 apiService: WeatherService()
			 ),
			 locationService: LocationManager()
		 )
	 )
        let view: UIView = UIHostingController(rootView: welcomeView).view
        //
        assertSnapshot(of: view, as: .image(size: view.intrinsicContentSize))
    }
    func testWeatherView() throws {
		//
        let weatherView = WeatherView(
			weatherViewModel:WeatherViewModel(
			 weatherService: WeatherManager(
				 apiService: WeatherService()
			 ),
			 locationService: LocationManager()
		 )
	 )
        let view: UIView = UIHostingController(rootView: weatherView).view
        //
        assertSnapshot(of: view, as: .image(size: view.intrinsicContentSize))
    }
}
