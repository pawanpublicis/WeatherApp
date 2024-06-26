//
//  WeatherInfoView.swift
//  WeatherApp
//
//  Created by Pawan on 26/06/24.
//

import SwiftUI

struct WeatherInfoView: View {
	let weather: Weather?

	var body: some View {
		VStack {
			HStack {
				VStack(spacing: 20) {
					if let weatherConditionId = weather?.id {
						Text(getWeatherIcon(condition: Int(weatherConditionId)))
							.font(.system(size: 40))
					}
					Text("\(weather?.condition ?? "...")")
				}
				.frame(width: 150, alignment: .leading)
				Spacer()
				Text("\(weather?.feelsLike ?? "0.0°")")
					.font(.system(size: 100))
					.fontWeight(.semibold)
					.padding()
			}
		}
	}
}
