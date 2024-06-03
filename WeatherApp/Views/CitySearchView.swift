//
//  CitySearchView.swift
//  WeatherApp
//
//  Created by Pawan on 29/05/24.
//

import SwiftUI

struct CitySearchView: View {
	//
	@State private var cityName: String = ""
	var citySearchClosure: (_ cityName: String) -> Void
	@Binding var isPresented: Bool
	//
    var body: some View {
		ZStack {
			VStack(alignment: .center) {
				Text("Check the weather for any city around the globe")
					.font(.footnote)
					.padding(.vertical, 16)
				HStack {
					Text("")
						.padding(.horizontal, 8)
					TextField("Enter city name", text: $cityName)
						.textFieldStyle(.plain)
						.foregroundStyle(Color.black)
						.accessibilityIdentifier("Search")
				}
				.frame(height: 50)
				.background(Color.white)
				.clipShape(.capsule)
				.padding()
				
				Button {
					if !cityName.isEmpty {
						citySearchClosure(cityName)
						isPresented = false
					}
				} label: {
					Text("Search")
						.font(.title2)
						.foregroundStyle(Color.white)
						.padding(.horizontal, 20)
				}
				.buttonStyle(.bordered)
				.tint(.black)
				.clipShape(.capsule)
				.padding(.vertical, 20)
                .accessibilityIdentifier("CitySearchButton")
				
				Spacer()
			}
		}
		.background(Color(hue: 0.636, saturation: 0.78, brightness: 0.773))
    }
}

#Preview {
	CitySearchView(citySearchClosure: { _ in }, isPresented: .constant(true))
}
