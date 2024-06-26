//
//  WeatherDetailsView.swift
//  WeatherApp
//
//  Created by Pawan on 26/06/24.
//

import SwiftUI

struct WeatherDetailsView: View {
	let weather: Weather?

	var body: some View {
		VStack {
			Spacer()
			VStack(alignment: .leading, spacing: 20) {
				Text("Weather now")
					.bold()
					.padding(.bottom)
				HStack {
					WeatherRowView(logo: "thermometer", name: "Min temp", value: "\(weather?.tempMin ?? "0.0°")")
					Spacer()
					WeatherRowView(logo: "thermometer", name: "Max temp", value: "\(weather?.tempMax ?? "0.0°")")
				}
				HStack {
					WeatherRowView(logo: "wind", name: "Wind speed", value: "\(weather?.windSpeed ?? "0.0 m/s")")
					Spacer()
					WeatherRowView(logo: "humidity", name: "Humidity", value: "\(weather?.humidity ?? "0.0") %")
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
