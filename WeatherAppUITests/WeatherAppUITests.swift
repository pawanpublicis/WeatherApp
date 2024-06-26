//
//  WeatherAppUITests.swift
//  WeatherAppUITests
//
//  Created by Pawan Rai on 24/05/24.
//

import XCTest

final class WeatherAppUITests: XCTestCase {

	override func setUpWithError() throws {
		continueAfterFailure = false
	}

	override func tearDownWithError() throws {
	}

	func testSearchCity() throws {
        //
        XCUIDevice.shared.orientation = .portrait
        //
		let app = XCUIApplication()
		app.launch()
		
		// Tap the button to make WeatherView appear
		let shareLocationButton = app.otherElements["ShareLocationButton"]
		XCTAssertTrue(shareLocationButton.waitForExistence(timeout: 10), "Share location button should exist")
		shareLocationButton.tap()
        
		// Check for and handle location permission dialog
		if app.alerts.element.exists {
			app.buttons["OK"].tap()
		}
		
		// Remove the interruption monitor after handling the dialog
		let locationDialogMonitor = addUIInterruptionMonitor(withDescription: "Automatically allow location permissions") { alert in
			alert.buttons["OK"].tap()
			return true
		}
		
		// Perform interactions
		app.swipeUp()
		self.removeUIInterruptionMonitor(locationDialogMonitor)
		
		// Tap the button to make the CitySearchView appear
		let searchButton = app.buttons["SearchButton"]
		XCTAssertTrue(searchButton.waitForExistence(timeout: 20), "Search button should exist")
		searchButton.tap()
		
		// Interact with the search field in CitySearchView
		let searchField = app.textFields["Search"]
		XCTAssertTrue(searchField.waitForExistence(timeout: 5), "Search field should exist")
				searchField.tap()
		searchField.typeText("Noida")
        
        // Tap on Search button
        let citySearchButton = app.buttons["CitySearchButton"]
        XCTAssertTrue(searchButton.waitForExistence(timeout: 5), "City search button should exist")
        citySearchButton.tap()
        
		// Check if city name label exist
		let cityNameLabel = app.staticTexts["CityNameLabel"]
        XCTAssertTrue(cityNameLabel.waitForExistence(timeout: 5), "City name label should exist")
	}

	func testLaunchPerformance() throws {
		if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
			// This measures how long it takes to launch your application.
			measure(metrics: [XCTApplicationLaunchMetric()]) {
				XCUIApplication().launch()
			}
		}
	}
}
