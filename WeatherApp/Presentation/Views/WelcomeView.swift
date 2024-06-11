//
//  WelcomeView.swift
//  WeatherApp
//
//  Created by Pawan Rai on 26/05/24.
//

import SwiftUI
import CoreLocationUI

struct WelcomeView: View {
	//
	@ObservedObject var weatherViewModel: WeatherViewModel
    
    var body: some View {
        VStack {
            VStack(spacing: 20) {
                Text("Welcome to the Weather App")
                    .bold()
                    .font(.title)
                Text("Please share your current location to get the weather in your area")
                    .padding()
            }
            .multilineTextAlignment(.center)
            .padding()
            
            LocationButton(.shareCurrentLocation) {
				weatherViewModel.requestLocation()
            }
            .cornerRadius(30)
            .symbolVariant(.fill)
			.foregroundStyle(Color.white)
			.accessibilityIdentifier("ShareLocationButton")
        }
    }
}

#Preview {
	WelcomeView(
		weatherViewModel:WeatherViewModel(
			weatherService: WeatherManager(
				apiService: WeatherService()
			),
			locationService: LocationManager()
		)
	)
}
