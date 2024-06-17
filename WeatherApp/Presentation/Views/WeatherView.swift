//
//  WeatherView.swift
//  WeatherApp
//
//  Created by Pawan Rai on 26/05/24.
//

import SwiftUI
import CoreLocation

struct WeatherView: View {
	//
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
					HStack {
						VStack(alignment: .leading, spacing: 5) {
							Text(weatherViewModel.weather?.name ?? "Loading...")
								.bold()
								.font(.title)
								.accessibilityIdentifier("CityNameLabel")
							
							Text("Today, \(Date().formatted(.dateTime.month().day().hour().minute()))")
								.fontWeight(.light)
						}
						.frame(maxWidth: .infinity, alignment: .leading)
						
						Spacer()
						
						Button {
							showingSheet.toggle()
						} label: {
							Image(systemName: "magnifyingglass")
								.font(.system(size: 24))
								.fontWeight(.light)
						}
						.sheet(isPresented: $showingSheet) {
							CitySearchView(
								citySearchClosure: {
									cityName in
									weatherViewModel.fetchWeather(for: cityName)
								},
								isPresented: $showingSheet
							)
						}
						.accessibilityIdentifier("SearchButton")
					}
					
					Spacer()
					
					VStack {
						HStack {
							VStack(spacing: 20) {
								if let weatherConditionId = weatherViewModel.weather?.id {
									Text(getWeatherIcon(condition: Int(weatherConditionId)))
										.font(.system(size: 40))
								}
								
								Text("\(weatherViewModel.weather?.condition ?? "...")")
							}
							.frame(width: 150, alignment: .leading)
							
							Spacer()
							
							Text(weatherViewModel.weather?.feelsLike ?? "0.0" + "°")
								.font(.system(size: 100))
								.fontWeight(.semibold)
								.padding()
						}
						
						Spacer()
							.frame(height:  80)
						
						AsyncImage(url: URL(string: "https://cdn.pixabay.com/photo/2020/01/24/21/33/city-4791269_960_720.png")) { image in
							image
								.resizable()
								.aspectRatio(contentMode: .fit)
								.frame(width: 350)
						} placeholder: {
							ProgressView()
						}
						
						Spacer()
					}
					.frame(maxWidth: .infinity, alignment: .trailing)
				}
				.padding()
				.foregroundStyle(Color.white)
				.frame(maxWidth: .infinity, alignment: .leading)
				
				VStack {
					Spacer()
					VStack(alignment: .leading, spacing: 20) {
						Text("Weather now")
							.bold()
							.padding(.bottom)
						
						HStack {
							WeatherRow(
								logo: "thermometer",
								name: "Min temp",
								value: weatherViewModel.weather?.tempMin ?? "0.0" + "°"
							)
							Spacer()
							WeatherRow(
								logo: "thermometer",
								name: "Max temp",
								value: weatherViewModel.weather?.tempMax ?? "0.0" + "°"
							)
						}
						
						HStack {
							WeatherRow(
								logo: "wind",
								name: "Wind speed",
								value: weatherViewModel.weather?.windSpeed ?? "0.0" + " m/s"
							)
							Spacer()
							WeatherRow(
								logo: "humidity",
								name: "Humidity",
								value: "\(weatherViewModel.weather?.humidity ?? "0.0")%"
							)
						}
					}
					.frame(maxWidth: .infinity, alignment: .leading)
					.padding()
					.padding(.bottom, 20)
					.foregroundColor(Color(hue: 0.656, saturation: 0.787, brightness: 0.354))
					.background(.white)
					.cornerRadius(20, corners: [.topLeft, .topRight])
				}
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
