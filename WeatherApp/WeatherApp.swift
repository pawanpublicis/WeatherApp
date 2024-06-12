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
                weatherService: WeatherManager(
                    apiService: WeatherService()
                ),
                locationService: LocationManager()
            )
            ContentView(weatherViewModel: weatherViewModel)
        }
    }
}
