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
        let welcomeView = WelcomeView()
        let view: UIView = UIHostingController(rootView: welcomeView).view
        //
        assertSnapshot(of: view, as: .image(size: view.intrinsicContentSize))
    }
    func testWeatherView() throws {
        let coordinate = CLLocationCoordinate2D(
            latitude: 37.7749,
            longitude: -122.4194
        )
        let weatherView = WeatherView(
            weatherManager: WeatherManager(
                apiService: WeatherService()
            ),
            coordinates: coordinate
        )
        let view: UIView = UIHostingController(rootView: weatherView).view
        //
        assertSnapshot(of: view, as: .image(size: view.intrinsicContentSize))
    }
}
