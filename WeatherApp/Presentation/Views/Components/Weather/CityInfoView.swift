//
//  CityInfoView.swift
//  WeatherApp
//
//  Created by Pawan on 26/06/24.
//

import SwiftUI

struct CityInfoView: View {
	@Binding var showingSheet: Bool
	@ObservedObject var weatherViewModel: WeatherViewModel

	var body: some View {
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
					citySearchClosure: { cityName in
						weatherViewModel.fetchWeather(for: cityName)
					},
					isPresented: $showingSheet
				)
			}
			.accessibilityIdentifier("SearchButton")
		}
	}
}
