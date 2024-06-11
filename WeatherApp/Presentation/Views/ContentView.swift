//
//  ContentView.swift
//  WeatherApp
//
//  Created by Pawan Rai on 24/05/24.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
	@StateObject var weatherViewModel: WeatherViewModel = WeatherViewModel(
		weatherService: WeatherManager(
			apiService: WeatherService()
		),
		locationService: LocationManager()
	)
	
	var body: some View {
		VStack {
			if weatherViewModel.isLocationAuthorized {
				WeatherView(
					weatherViewModel: weatherViewModel
				)
				.frame(maxWidth: .infinity, maxHeight: .infinity)
			} else {
				WelcomeView(
					weatherViewModel: weatherViewModel
				)
				.frame(maxWidth: .infinity, maxHeight: .infinity)
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
