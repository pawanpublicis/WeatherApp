//
//  WeatherServiceTests.swift
//  WeatherAppTests
//
//  Created by Pawan on 17/06/24.
//

import XCTest
@testable import WeatherApp

class MockURLProtocol: URLProtocol {
	static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?

	override class func canInit(with request: URLRequest) -> Bool {
		return true
	}

	override class func canonicalRequest(for request: URLRequest) -> URLRequest {
		return request
	}

	override func startLoading() {
		guard let handler = MockURLProtocol.requestHandler else {
			XCTFail("Handler is unavailable.")
			return
		}
		
		do {
			let (response, data) = try handler(request)
			client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
			client?.urlProtocol(self, didLoad: data)
			client?.urlProtocolDidFinishLoading(self)
		} catch {
			client?.urlProtocol(self, didFailWithError: error)
		}
	}

	override func stopLoading() {
	}
}

final class WeatherServiceTests: XCTestCase {
	var weatherService: WeatherService!
	
	override func setUp() {
		super.setUp()
		//
		let config = URLSessionConfiguration.ephemeral
		config.protocolClasses = [MockURLProtocol.self]
		let session = URLSession(configuration: config)
		
		weatherService = WeatherService(session: session)
	}
	
	override func tearDown() {
		weatherService = nil
		super.tearDown()
	}
	
	func testRequestSuccess() async throws {
		let mockResponseData = """
  {
   "coord": { "lon": -122.4194, "lat": 37.7749 },
   "weather": [{ "id": 800, "main": "Clear", "description": "clear sky", "icon": "01d" }],
   "main": { "temp": 75.0, "feels_like": 74.0, "temp_min": 72.0, "temp_max": 78.0, "pressure": 1012, "humidity": 60 },
   "name": "San Francisco",
   "wind": { "speed": 5.0, "deg": 270 }
  }
  """.data(using: .utf8)!
		
		MockURLProtocol.requestHandler = { request in
			let response = HTTPURLResponse(url: request.url!,
										   statusCode: 200,
										   httpVersion: nil,
										   headerFields: nil)!
			return (response, mockResponseData)
		}
		
		let endpoint = WeatherAPI.Endpoint.cityWeather(cityName: "San Francisco")
		let response: WeatherResponse = try await weatherService.request(endpoint, responseType: WeatherResponse.self)
		
		XCTAssertEqual(response.name, "San Francisco")
		XCTAssertEqual(response.main.temp, 75.0)
		XCTAssertEqual(response.weather.first?.main, "Clear")
	}
	
	func testRequestFailed() async {
		MockURLProtocol.requestHandler = { request in
			throw URLError(.notConnectedToInternet)
		}
		
		let endpoint = WeatherAPI.Endpoint.cityWeather(cityName: "San Francisco")
		
		do {
			let _: WeatherResponse = try await weatherService.request(endpoint, responseType: WeatherResponse.self)
			XCTFail("Expected request to throw, but it did not")
		} catch {
			XCTAssertEqual(error as? WeatherAPIError, WeatherAPIError.requestFailed)
		}
	}
	
	func testRequestInvalidResponse() async {
		MockURLProtocol.requestHandler = { request in
			let response = HTTPURLResponse(url: request.url!,
										   statusCode: 500,
										   httpVersion: nil,
										   headerFields: nil)!
			return (response, Data())
		}
		
		let endpoint = WeatherAPI.Endpoint.cityWeather(cityName: "San Francisco")
		
		do {
			let _: WeatherResponse = try await weatherService.request(endpoint, responseType: WeatherResponse.self)
			XCTFail("Expected request to throw, but it did not")
		} catch {
			XCTAssertEqual(error as? WeatherAPIError, WeatherAPIError.invalidResponse)
		}
	}
	
	func testRequestDecodingFailed() async {
		let invalidJSONData = "invalid json".data(using: .utf8)!
		
		MockURLProtocol.requestHandler = { request in
			let response = HTTPURLResponse(url: request.url!,
										   statusCode: 200,
										   httpVersion: nil,
										   headerFields: nil)!
			return (response, invalidJSONData)
		}
		
		let endpoint = WeatherAPI.Endpoint.cityWeather(cityName: "San Francisco")
		
		do {
			let _: WeatherResponse = try await weatherService.request(endpoint, responseType: WeatherResponse.self)
			XCTFail("Expected request to throw, but it did not")
		} catch {
			XCTAssertEqual(error as? WeatherAPIError, WeatherAPIError.decodingFailed)
		}
	}
}
