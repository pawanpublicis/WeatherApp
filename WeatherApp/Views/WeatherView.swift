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
	@ObservedObject var weatherManager: WeatherManager
	var coordinates: CLLocationCoordinate2D
	//
	@State private var weather: WeatherResponse?
	@State private var showingSheet = false
	@State private var isLoading: Bool = true
    
    var body: some View {
        ZStack(alignment: .leading) {
            VStack {
				HStack {
					VStack(alignment: .leading, spacing: 5) {
						Text(weather?.name ?? "Loading...")
							.bold()
							.font(.title)
						
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
								fetchWeather(for: cityName)
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
							if let weatherConditionId = weather?.weather.first?.id {
								Text(getWeatherIcon(condition: Int(weatherConditionId)))
									.font(.system(size: 40))
							}
                            
                            Text("\(weather?.weather[0].main ?? "...")")
                        }
                        .frame(width: 150, alignment: .leading)
                        
                        Spacer()
                        
                        Text(weather?.main.feelsLike.roundDouble() ?? "0.0" + "°")
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
							value: weather?.main.tempMin.roundDouble() ?? "0.0" + "°"
						)
						Spacer()
						WeatherRow(
							logo: "thermometer",
							name: "Max temp",
							value: weather?.main.tempMax.roundDouble() ?? "0.0" + "°"
						)
					}
					
					HStack {
						WeatherRow(
							logo: "wind",
							name: "Wind speed",
							value: weather?.wind.speed.roundDouble() ?? "0.0" + " m/s"
						)
						Spacer()
						WeatherRow(
							logo: "humidity",
							name: "Humidity",
							value: "\(weather?.main.humidity.roundDouble() ?? "0.0")%"
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
		.background(Color(hue: 0.636, saturation: 0.78, brightness: 0.773))
        .preferredColorScheme(.light)
		.onAppear {
			fetchWeather()
		}
		.onChange(of: coordinates) { _ in
			fetchWeather()
		}
    }
	
	private func fetchWeather(for city: String? = nil) {
		isLoading = true
		Task {
			do {
				if let city = city {
					weather = try await weatherManager.getCityWeather(city)
				} else {
					weather = try await weatherManager.getCurrentWeather(
						coordinates.latitude,
						longitude: coordinates.longitude
					)
				}
			} catch {
				debugPrint("Error getting weather: \(error)")
			}
			isLoading = false
		}
	}
}

#Preview {
	WeatherView(weatherManager: WeatherManager(apiService: WeatherService()),
				coordinates: CLLocationCoordinate2DMake(26.846694, 80.946166))
}
