//
//  ContentView.swift
//  WeatherApp
//
//  Created by Pawan Rai on 24/05/24.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
	@StateObject var locationManager: LocationManager = LocationManager()
	@StateObject var weatherManager: WeatherManager = WeatherManager(apiService: WeatherService())
	
	var body: some View {
		VStack {
			if let location = locationManager.location {
				WeatherView(
					weatherManager: weatherManager,
					coordinates: location
				)
				.frame(maxWidth: .infinity, maxHeight: .infinity)
			} else {
				if locationManager.isLoading {
					LoadingView()
						.frame(maxWidth: .infinity, maxHeight: .infinity)
				} else if locationManager.isAuthorized {
					LoadingView()
						.onAppear {
							locationManager.requestLocation()
						}
						.frame(maxWidth: .infinity, maxHeight: .infinity)
				} else {
					WelcomeView()
						.environmentObject(locationManager)
						.frame(maxWidth: .infinity, maxHeight: .infinity)
				}
			}
		}
		.edgesIgnoringSafeArea(.bottom)
		.background(Color(hue: 0.636, saturation: 0.78, brightness: 0.773))
		.foregroundStyle(Color.white)
		.preferredColorScheme(.dark)
	}
}

#Preview {
    ContentView()
}
