//
//  WeatherApp.swift
//  WeatherApp
//
//  Created by Pawan Rai on 24/05/24.
//

import SwiftUI

@main
struct WeatherApp: App {
    var body: some Scene {
        WindowGroup {
            let weatherViewModel: WeatherViewModel = WeatherViewModel(
				weatherService: WeatherUseCase(
					repository: DefaultWeatherRepository(
						service: WeatherService()
					)
				),
				locationService: LocationUseCase(
					repository: DefaultLocationRepository(
						service: LocationService(),
						isLocationAuthorized: false
					)
				)
            )
            ContentView(weatherViewModel: weatherViewModel)
        }
    }
}
