//
//  CitySearchView.swift
//  WeatherApp
//
//  Created by Pawan on 29/05/24.
//

import SwiftUI

struct CitySearchView: View {
	@State private var cityName: String = ""
	var citySearchClosure: (_ cityName: String) -> Void
	@Binding var isPresented: Bool
	
	var body: some View {
		ZStack {
			VStack(alignment: .center) {
				Text("Check the weather for any city around the globe")
					.font(.footnote)
					.padding(.vertical, 16)
				
				HStack {
					CustomTextField(
						text: $cityName,
						placeholder: "Enter city name"
					)
					.padding()
					.tint(.white)
					.frame(height: 44)
					.overlay(
						RoundedRectangle(
							cornerRadius: 14
						)
						.stroke(.white, lineWidth: 1)
					)
					.accessibilityIdentifier("Search")
				}
				.padding()
				
				Button {
					if !cityName.isEmpty {
						citySearchClosure(cityName)
						isPresented = false
					}
				} label: {
					Text("Search")
						.font(.title2)
						.foregroundColor(.white)
						.padding(.horizontal, 20)
				}
				.buttonStyle(BorderlessButtonStyle())
				.tint(.black)
				.frame(height: 50)
				.background(Color.blue)
				.clipShape(Capsule())
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
