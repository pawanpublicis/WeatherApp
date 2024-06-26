//
//  WeatherView.swift
//  WeatherApp
//
//  Created by Pawan Rai on 26/05/24.
//

import SwiftUI
import CoreLocation

struct WeatherView: View {
	@ObservedObject var weatherViewModel: WeatherViewModel
	@State private var showingSheet = false

	var body: some View {
		ZStack(alignment: .leading) {
			if weatherViewModel.isLoading {
				LoadingView()
					.frame(maxWidth: .infinity, maxHeight: .infinity)
					.background(Color(hue: 0.636, saturation: 0.78, brightness: 0.773))
			} else {
				VStack {
					CityInfoView(showingSheet: $showingSheet, weatherViewModel: weatherViewModel)
					WeatherInfoView(weather: weatherViewModel.weather)
					Spacer().frame(height: 80)
					WeatherIconView()
					Spacer()
				}
				.padding()
				.foregroundStyle(Color.white)
				.frame(maxWidth: .infinity, alignment: .leading)
				WeatherDetailsView(weather: weatherViewModel.weather)
			}
		}
		.background(Color(hue: 0.636, saturation: 0.78, brightness: 0.773))
		.preferredColorScheme(.light)
		.onAppear {
			weatherViewModel.fetchWeatherForCurrentLocation()
		}
	}
}

#Preview {
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
	return WeatherView(weatherViewModel: weatherViewModel)
}
