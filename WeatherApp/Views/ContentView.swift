//
//  ContentView.swift
//  WeatherApp
//
//  Created by Pawan Rai on 24/05/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var locationManager: LocationManager = LocationManager()
    var weatherManager = WeatherManager()
    @State var weather: ResponseBody?
    
    var body: some View {
        VStack {
            if let location = locationManager.location {
                if let weather = weather {
                    WeatherView(weather: weather)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    LoadingView()
                        .task {
                            do {
                                weather = try await weatherManager.getCurrentWeather(
                                    latitude: location.latitude,
                                    longitude: location.longitude
                                )
                            }
                            catch {
                                debugPrint("Error getting weather: \(error)")
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            } else {
                if locationManager.isLoading {
                    LoadingView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    WelcomeView()
                        .environmentObject(locationManager)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .background(Color(hue: 0.636, saturation: 0.78, brightness: 0.773))
        .preferredColorScheme(.light)
    }
}

#Preview {
    ContentView()
}
