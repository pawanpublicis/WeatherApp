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
		let app = XCUIApplication()
		app.launch()
		
		// Tap the button to make WeatherView appear
		let shareLocationButton = app.buttons["ShareLocationButton"]
		XCTAssertTrue(shareLocationButton.waitForExistence(timeout: 5), "Share location button button should exist")
		shareLocationButton.tap()
		
		// Tap the button to make the CitySearchView appear
		let searchButton = app.buttons["SearchButton"]
		XCTAssertTrue(searchButton.waitForExistence(timeout: 5), "Search button should exist")
		searchButton.tap()
		
		// Interact with the search field in CitySearchView
		let searchField = app.searchFields["Search"]
		XCTAssertTrue(searchField.waitForExistence(timeout: 5), "Search field should exist")
				searchField.tap()
		searchField.typeText("Noida")
		
		// Check if the search results appear
		let tablesQuery = app.tables
		XCTAssertTrue(tablesQuery.cells.count > 0, "There should be at least one search result")
	}

	func testWeatherDetailsDisplay() throws {
		let app = XCUIApplication()
		app.launch()
		
		let tablesQuery = app.tables
		let firstCell = tablesQuery.cells.element(boundBy: 0)
		XCTAssertTrue(firstCell.waitForExistence(timeout: 5), "The first cell should exist")
		firstCell.tap()
		
		let weatherDetail = app.staticTexts["Weather Detail"]
		XCTAssertTrue(weatherDetail.waitForExistence(timeout: 5), "Weather Detail should be displayed")
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
